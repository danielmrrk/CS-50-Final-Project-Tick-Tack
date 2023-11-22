import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tic_tac/database/statistic/challenge.dart';
import 'package:tic_tac/database/statistic/statistic_database.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';

const kWinKey = 'win';
const kDrawKey = 'draw';
const kLossKey = 'loss';
const kWinRate = 'win_rate';
const kUserStatusKey = 'user_status';
const kRankKey = '$kUserStatusKey/rank';
const kExpKey = '$kUserStatusKey/exp';

const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);

final userStatisticProvider = StateNotifierProvider<UserStatisticService, Map<String, String>>((ref) {
  return UserStatisticService();
});

class UserStatisticService extends StateNotifier<Map<String, String>> {
  UserStatisticService() : super({}) {
    readAllUserStats();
  }

  Future<void> readAllUserStats() async {
    Map<String, String> userStatistic = await _storage.readAll();
    if (userStatistic.isEmpty) {
      userStatistic = await _initWithFreshData();
    }
    int winCount = 0;
    int drawCount = 0;
    int lossCount = 0;
    for (var rank in Difficulty.ranks) {
      int specificWinCount = int.parse(userStatistic["$kWinKey/${rank.displayName}"] ?? '0');
      int specificLossCount = int.parse(userStatistic["$kLossKey/${rank.displayName}"] ?? '0');
      winCount += specificWinCount;
      drawCount += int.parse(userStatistic["$kDrawKey/${rank.displayName}"] ?? '0');
      lossCount += specificLossCount;
      userStatistic["$kWinRate/${rank.displayName}"] = "${_calculateWinRate(specificWinCount, specificLossCount)}%";
    }
    userStatistic[kWinRate] = "${_calculateWinRate(winCount, lossCount)}%";
    userStatistic[kWinKey] = winCount.toString();
    userStatistic[kDrawKey] = drawCount.toString();
    userStatistic[kLossKey] = lossCount.toString();
    state = userStatistic;
  }

  int _calculateWinRate(int winCount, int lossCount) {
    return winCount + lossCount == 0 ? 0 : (winCount * 100 ~/ (winCount + lossCount));
  }

  Future<Map<String, String>> _initWithFreshData() async {
    for (var rank in Difficulty.ranks) {
      _storage.write(key: "$kWinKey/${rank.displayName}", value: '0');
      _storage.write(key: "$kDrawKey/${rank.displayName}", value: '0');
      _storage.write(key: "$kLossKey/${rank.displayName}", value: '0');
      _storage.write(key: "$kWinRate/${rank.displayName}", value: '0');
    }
    _storage.write(key: kWinKey, value: '0');
    _storage.write(key: kDrawKey, value: '0');
    _storage.write(key: kLossKey, value: '0');
    _storage.write(key: kWinRate, value: '0%');
    _storage.write(key: kRankKey, value: 'Drunkard');
    _storage.write(key: kExpKey, value: '0');
    return await _storage.readAll();
  }

  Future<void> updateGameCount(String difficultyDisplayName, String resultKey, int? moves) async {
    final difficultyKey = "$resultKey/$difficultyDisplayName";
    final gameCount = await _storage.read(key: difficultyKey);
    if (gameCount == null) {
      await _storage.write(key: difficultyKey, value: '1');
      state[difficultyKey] = '1';
      state[resultKey] = '1';
    } else {
      await _storage.write(key: difficultyKey, value: (int.parse(gameCount) + 1).toString());
      state[difficultyKey] = (int.parse(gameCount) + 1).toString();
      state[resultKey] = (int.parse(state[resultKey]!) + 1).toString();
    }
    if (resultKey == kLossKey || resultKey == kWinKey) {
      state[kWinRate] = "${_calculateWinRate(int.tryParse(state[kWinKey]!)!, int.tryParse(state[kLossKey]!)!)}%";
      state["$kWinRate/$difficultyDisplayName"] =
          "${_calculateWinRate(int.tryParse(state["$kWinKey/$difficultyDisplayName"]!)!, int.tryParse(state["$kLossKey/$difficultyDisplayName"]!)!)}%";
    }
    StatisticDatabase.instance.onResultUpdateChallenge(
      resultKey: resultKey,
      difficultyDisplayName: difficultyDisplayName,
      moves: moves,
    );
  }

  Future<bool> maybeUpdateUserStatus(Challenge challenge) async {
    final userExp = await _storage.read(key: kExpKey);
    final rank = await _storage.read(key: kRankKey);
    Difficulty difficulty = Difficulty.fromStorage(rank ?? "");
    if (userExp == null) {
      await _storage.write(key: kExpKey, value: '0');
    } else {
      if (difficulty != Difficulty.darkWizard) {
        final expAfterRankUp = int.parse(userExp) + challenge.exp - difficulty.expRequiredForRankUp;
        if (expAfterRankUp >= 0) {
          await _storage.write(key: kExpKey, value: (expAfterRankUp).toString());
          state[kExpKey] = (expAfterRankUp).toString();
          await _updateRank(rank);
          await StatisticDatabase.instance.onCollectUpdateChallenge(challenge);
          return true;
        } else {
          await _storage.write(key: kExpKey, value: (int.parse(userExp) + challenge.exp).toString());
          state[kExpKey] = (int.parse(userExp) + challenge.exp).toString();
        }
      } else {
        await _storage.write(key: kExpKey, value: ((int.parse(userExp) + challenge.exp).toString()).toString());
        state[kExpKey] = ((int.parse(userExp) + challenge.exp).toString()).toString();
      }
    }
    await StatisticDatabase.instance.onCollectUpdateChallenge(challenge);
    return false;
  }

  Future<void> _updateRank(String? rank) async {
    if (rank == null) {
      await _storage.write(key: kRankKey, value: 'Drunkard');
    } else {
      switch (rank) {
        case 'Drunkard':
          rank = 'Novice';
          await _storage.write(key: kRankKey, value: rank);
          break;
        case 'Novice':
          rank = 'White Knight';
          await _storage.write(key: kRankKey, value: rank);
          break;
        case 'White Knight':
          rank = 'Dark Wizard';
          await _storage.write(key: kRankKey, value: rank);
          break;
      }
      state[kRankKey] = rank;
      await StatisticDatabase.instance.updateUnshowableChallenges(rank);
    }
  }

  Future<void> resetUserStatistic() async {
    await StatisticDatabase.instance.resetChallenges();
    state = await _initWithFreshData();
  }
}
