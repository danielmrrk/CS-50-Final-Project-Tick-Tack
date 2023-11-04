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

  int? getTime() {
    return state;
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
  GameService(this._timeService)
      : super(
          List.generate(
            3,
            (index) => List.generate(3, (index) => "' '"),
          ),
        );

  int _moves = 0;
  String compSymbol = "O";
  String playerSymbol = "X";
  final TimeService _timeService;

  bool onPlayerPlacedMove(int row, int col, Difficulty difficultyDisplay) {
    _onMovePlaced(playerSymbol, row, col);
    if (_checkGameStatus(playerSymbol, difficultyDisplay)) {
      return true;
    }

    _movePlacedByComp();
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
    });
  }

  bool _checkGameStatus(String currentPlayer, Difficulty difficultyDisplay) {
    if (_checkWin(currentPlayer)) {
      _timeService.cancelTimer();
      CustomDialog.showUnclosableGetDialog(
        currentPlayer == playerSymbol ? "Triumph is yours. A well deserved victory!" : "What an unfortunate loss. Good luck next time!",
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

  void _movePlacedByComp() {
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
