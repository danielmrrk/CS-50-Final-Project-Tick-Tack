import "dart:async";
import 'dart:math';
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:tic_tac/general/util/array_position_2d.dart";
import "package:tic_tac/general/util/dialog.dart";
import "package:tic_tac/general/util/snackbar.dart";
import "package:tic_tac/main_sceen/difficulty.dart";
import 'package:tic_tac/service/model_service.dart';

final timeProvider = StateNotifierProvider<TimeService, int?>((ref) => TimeService());

class TimeService extends StateNotifier<int?> {
  TimeService() : super(null);
  Timer? _timer;

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
          CustomDialog.showUnclosableGetDialog(
            "You lost on time. Good luck next time.",
            CustomDialog.buildFixedGameDialogContent(),
          );

          timer.cancel();
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
  return GameService(ref.read(timeProvider.notifier));
});

class GameService extends StateNotifier<List<List<String>>> {
  GameService._(this._timeService, this.compSymbol, this._playerSymbol)
      : super(
          List.generate(
            3,
            (index) => List.generate(3, (index) => "' '"),
          ),
        );

  factory GameService(TimeService timeService) {
    bool randomTurn = Random().nextInt(2) == 0;
    String compSymbol = randomTurn ? "O" : "X";
    String playerSymbol = randomTurn ? "X" : "O";
    return GameService._(timeService, compSymbol, playerSymbol);
  }

  int _moves = 0;
  String compSymbol;
  String _playerSymbol;
  final TimeService _timeService;

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

  bool _checkGameStatus(String currentPlayer, Difficulty difficultyDisplay) {
    if (_checkWin(currentPlayer)) {
      _timeService.cancelTimer();
      CustomDialog.showUnclosableGetDialog(
        currentPlayer == _playerSymbol ? "Triumph is yours. A well deserved victory!" : "What an unfortunate loss. Good luck next time!",
        CustomDialog.buildFixedGameDialogContent(),
      );
      return true;
    } else if (_moves == 9) {
      _timeService.cancelTimer();
      CustomDialog.showUnclosableGetDialog(
        "Getting a draw is sometimes the best.",
        CustomDialog.buildFixedGameDialogContent(),
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
