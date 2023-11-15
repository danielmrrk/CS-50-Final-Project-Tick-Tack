import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

class UserStatisticService {
  static final instance = UserStatisticService._init();
  UserStatisticService._init();

  Future<Map<String, String>> readAllUserStats() async {
    Map<String, String> userStatistic = await _storage.readAll();
    if (userStatistic.isEmpty) {
      userStatistic = await _initAndWriteData();
    }
    int winCount = 0;
    int drawCount = 0;
    int lossCount = 0;
    for (var rank in Difficulty.ranks) {
      winCount += int.parse(userStatistic["$kWinKey/${rank.displayName}"] ?? '0');
      drawCount += int.parse(userStatistic["$kDrawKey/${rank.displayName}"] ?? '0');
      lossCount += int.parse(userStatistic["$kLossKey/${rank.displayName}"] ?? '0');
    }
    userStatistic[kWinRate] = winCount + lossCount == 0 ? '0' : (winCount * 100 ~/ (winCount + lossCount)).toString();
    userStatistic[kWinKey] = winCount.toString();
    userStatistic[kDrawKey] = drawCount.toString();
    userStatistic[kLossKey] = lossCount.toString();
    return userStatistic;
  }

  Future<Map<String, String>> _initAndWriteData() async {
    for (var rank in Difficulty.ranks) {
      String rankKey = "$kWinKey/${rank.displayName}";
      _storage.write(key: "$kWinKey/$rankKey", value: '0');
      _storage.write(key: "$kDrawKey/$rankKey", value: '0');
      _storage.write(key: "$kLossKey/$rankKey", value: '0');
    }
    _storage.write(key: kRankKey, value: 'Drunkard');
    _storage.write(key: kExpKey, value: '0');
    return await _storage.readAll();
  }

  Future<void> updateGameCount(String difficultyDisplayName, String gameKey) async {
    final difficultyKey = "$gameKey/$difficultyDisplayName";
    final gameCount = await _storage.read(key: difficultyKey);
    if (gameCount == null) {
      await _storage.write(key: difficultyKey, value: '1');
    } else {
      await _storage.write(key: difficultyKey, value: (int.parse(gameCount) + 1).toString());
    }
  }

  Future<void> maybeUpdateUserStatus(int exp) async {
    final userExp = await _storage.read(key: kExpKey);
    final rank = await _storage.read(key: kRankKey);
    Difficulty difficulty = Difficulty.fromStorage(rank ?? "");
    if (userExp == null) {
      await _storage.write(key: kExpKey, value: '0');
    } else {
      final expAfterRankUp = int.parse(userExp) + exp - difficulty.expRequiredForRankUp;
      if (expAfterRankUp >= 0) {
        await _storage.write(key: kExpKey, value: (expAfterRankUp).toString());
        _updateRank(rank);
      } else {
        await _storage.write(key: kExpKey, value: (int.parse(userExp) + exp).toString());
      }
    }
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
      await StatisticDatabase.instance.updateUnshowableChallenges(rank);
    }
  }
}
