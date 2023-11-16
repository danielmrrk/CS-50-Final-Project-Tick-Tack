import "dart:async";
import 'dart:math';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:tic_tac/general/util/array_position_2d.dart";
import "package:tic_tac/general/util/dialog.dart";
import "package:tic_tac/general/util/snackbar.dart";
import "package:tic_tac/main_sceen/difficulty.dart";
import 'package:tic_tac/service/model_service.dart';
import "package:tic_tac/statistic/user_statistic_service.dart";

final timeProvider = StateNotifierProvider<TimeService, int?>((ref) {
  ref.read(userStatisticProvider.notifier);
  return TimeService(ref.read(userStatisticProvider.notifier));
});

class TimeService extends StateNotifier<int?> {
  TimeService(this._userStatisticService) : super(null);
  Timer? _timer;

  final UserStatisticService _userStatisticService;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer(Difficulty difficultyDisplay) {
    state = int.tryParse(difficultyDisplay.time);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state != null) {
        if (state! > 1) {
          state = state! - 1;
        } else {
          state = state! - 1;
          CustomDialog.showGetDialog(
            title: "You lost on time. Good luck next time.",
            content: CustomDialog.buildFixedGameDialogContent(),
          );
          timer.cancel();
          _userStatisticService.updateGameCount(
            difficultyDisplay.displayName,
            kLossKey,
            null,
          );
        }
      }
    });
  }

  void resetTimer(Difficulty difficultyDisplay) {
    _timer?.cancel();
    startTimer(difficultyDisplay);
  }

  void cancelTimer() {
    _timer?.cancel();
  }
}

final gameProvider = StateNotifierProvider<GameService, List<List<String>>>((ref) {
  return GameService(
    ref.read(timeProvider.notifier),
    ref.read(userStatisticProvider.notifier),
  );
});

class GameService extends StateNotifier<List<List<String>>> {
  GameService._(this._timeService, this._userStatisticService, this.compSymbol, this._playerSymbol)
      : super(
          List.generate(
            3,
            (index) => List.generate(3, (index) => "' '"),
          ),
        );

  factory GameService(TimeService timeService, UserStatisticService userStatisticService) {
    bool randomTurn = Random().nextInt(2) == 0;
    String compSymbol = randomTurn ? "O" : "X";
    String playerSymbol = randomTurn ? "X" : "O";
    return GameService._(timeService, userStatisticService, compSymbol, playerSymbol);
  }

  int _moves = 0;
  String compSymbol;
  String _playerSymbol;
  final TimeService _timeService;
  final UserStatisticService _userStatisticService;

  bool onPlayerPlacedMove(int row, int col, Difficulty difficultyDisplay) {
    _onMovePlaced(_playerSymbol, row, col);
    if (_checkGameStatus(_playerSymbol, difficultyDisplay)) {
      return true;
    }

    movePlacedByComp(difficultyDisplay);
    if (_checkGameStatus(compSymbol, difficultyDisplay)) {
      return true;
    }
    _timeService.resetTimer(difficultyDisplay);
    return false;
  }

  void clear() {
    Future.microtask(() {
      state = List.generate(3, (index) => List.generate(3, (index) => "' '"));
      _moves = 0;
      bool randomTurn = Random().nextInt(2) == 0;
      compSymbol = randomTurn ? "O" : "X";
      _playerSymbol = randomTurn ? "X" : "O";
    });
  }

  bool _checkGameStatus(String currentPlayer, Difficulty difficulty) {
    if (_checkWin(currentPlayer)) {
      _timeService.cancelTimer();
      bool userHasWon = currentPlayer == _playerSymbol;
      CustomDialog.showGetDialog(
        title: userHasWon ? "Triumph is yours. A well deserved victory!" : "What an unfortunate loss. Good luck next time!",
        content: CustomDialog.buildFixedGameDialogContent(),
      );
      _userStatisticService.updateGameCount(difficulty.displayName, userHasWon ? kWinKey : kLossKey, (_moves / 2).ceil());
      return true;
    } else if (_moves == 9) {
      _timeService.cancelTimer();
      CustomDialog.showGetDialog(
        title: "Getting a draw is sometimes the best.",
        content: CustomDialog.buildFixedGameDialogContent(),
      );
      _userStatisticService.updateGameCount(
        difficulty.displayName,
        kDrawKey,
        null,
      );
      return true;
    }
    return false;
  }

  bool _checkWin(String currentPlayer) {
    for (List<String> row in state) {
      if (row.every((cell) => cell.replaceAll("'", "") == currentPlayer)) {
        return true;
      }
    }
    for (int col = 0; col < 3; col++) {
      if (state.every((row) => row[col].replaceAll("'", "") == currentPlayer)) {
        return true;
      }
    }
    if ([0, 1, 2].every((i) => state[i][i].replaceAll("'", "") == currentPlayer) ||
        [0, 1, 2].every(
          (j) => state[2 - j][j].replaceAll("'", "") == currentPlayer,
        )) {
      return true;
    }
    return false;
  }

  void _onMovePlaced(String currentPlayer, int row, int col) {
    if (state[row][col] != "' '") {
      return;
    }
    _moves++;
    state[row][col] = "'$currentPlayer'";
  }

  void movePlacedByComp(Difficulty difficultyDisplay) {
    if (_moves == 0) {
      _compPlaysRandomMove();
    } else {
      if (Random().nextInt(101) <= difficultyDisplay.difficultyPercentage) {
        _compPlayBestMove();
      } else {
        _compPlaysRandomMove();
      }
    }
  }

  void _compPlaysRandomMove() {
    int randomCount = 0;
    int row;
    int col;
    do {
      if (randomCount == 10) {
        _compPlayBestMove();
        return;
      }
      Random rdm = Random();
      row = rdm.nextInt(3);
      col = rdm.nextInt(3);
      randomCount++;
    } while (!_isMoveValid(row, col));
    _onMovePlaced(compSymbol, row, col);
  }

  bool _isMoveValid(int row, int col) {
    return state[row][col] == "' '";
  }

  void _compPlayBestMove() {
    try {
      ArrayPosition2D position = ArrayPosition2D.argmax(
        TicTacToeModelService.qValuesMap!["$state/$compSymbol"],
      );
      _onMovePlaced(compSymbol, position.row, position.col);
    } catch (e) {
      if (e is NoSuchMethodError) {
        showSimpleGetSnackbar("Sorry the model does not know this position.", 3);
      }
      return;
    }
  }
}
