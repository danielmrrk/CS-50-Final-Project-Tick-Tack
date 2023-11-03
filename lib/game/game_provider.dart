import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:tic_tac/general/util/array_position_2d.dart";
import "package:tic_tac/general/util/dialog.dart";
import "package:tic_tac/general/util/snackbar.dart";
import "package:tic_tac/main_sceen/difficulty.dart";
import 'package:tic_tac/service/model_service.dart';

final timeProvider = StateNotifierProvider<TimeService, int?>((ref) => TimeService());

// the time depends on the difficulty!
class TimeService extends StateNotifier<int?> {
  TimeService() : super(null);
  static late Timer _timer;

  void startTimer(Difficulty difficultyDisplay, BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resetTimer(difficultyDisplay);
      if (state != null) {
        if (state! > 1) {
          state = state! - 1;
        } else {
          state = state! - 1;
          if (context.mounted) {
            CustomDialog.showUnclosableGetDialog(
              "You lost on time. Good luck next time.",
              CustomDialog.buildFixedGameDialogContent(),
            );
          }
          timer.cancel();
        }
      }
    });
  }

  void resetTimer(Difficulty difficultyDisplay) {
    state = int.tryParse(difficultyDisplay.time);
  }

  static void cancelTimer() {
    _timer.cancel();
  }
}

final gameProvider = StateNotifierProvider<GameService, Map<String, dynamic>>((ref) => GameService());

final gameService = GameService();

class GameService extends StateNotifier<Map<String, dynamic>> {
  GameService()
      : super({
          "board": List.generate(
            3,
            (index) => List.generate(3, (index) => "' '"),
          ),
          "compSymbol": "O",
          "playerSymbol": "X"
        });

  int _moves = 0;

  bool onPlayerPlacedMove(int row, int col, Difficulty difficultyDisplay) {
    _onMovePlaced(state["playerSymbol"], row, col);
    if (_checkGameStatus(state["playerSymbol"], difficultyDisplay)) {
      return true;
    }

    _movePlacedByComp();
    if (_checkGameStatus(state["compSymbol"], difficultyDisplay)) {
      return true;
    }
    return false;
  }

  void clear() {
    state["board"] = List.generate(3, (index) => List.generate(3, (index) => "' '"));
    _moves = 0;
  }

  List<List<String>> get board => state["board"];

  bool _checkGameStatus(String currentPlayer, Difficulty difficultyDisplay) {
    if (_checkWin(currentPlayer)) {
      TimeService().resetTimer(difficultyDisplay);
      CustomDialog.showUnclosableGetDialog(
        currentPlayer == state["playerSymbol"]
            ? "Triumph is yours. A well deserved victory!"
            : "What an unfortunate loss. Good luck next time!",
        CustomDialog.buildFixedGameDialogContent(),
      );
      return true;
    } else if (_moves == 9) {
      TimeService.cancelTimer();
      CustomDialog.showUnclosableGetDialog(
        "Getting a draw is sometimes the best.",
        CustomDialog.buildFixedGameDialogContent(),
      );
      return true;
    }
    return false;
  }

  bool _checkWin(String currentPlayer) {
    for (List<String> row in state["board"]) {
      if (row.every((cell) => cell.replaceAll("'", "") == currentPlayer)) {
        return true;
      }
    }
    for (int col = 0; col < 3; col++) {
      if (state["board"].every((row) => row[col].replaceAll("'", "") == currentPlayer)) {
        return true;
      }
    }
    if ([0, 1, 2].every((i) => state["board"][i][i].replaceAll("'", "") == currentPlayer) ||
        [0, 1, 2].every(
          (j) => state["board"][2 - j][j].replaceAll("'", "") == currentPlayer,
        )) {
      return true;
    }
    return false;
  }

  void _onMovePlaced(String currentPlayer, int row, int col) {
    if (state["board"][row][col] != "' '") {
      return;
    }
    _moves++;
    state["board"][row][col] = "'$currentPlayer'";
  }
  //widget.resetTimer();

  void _movePlacedByComp() {
    try {
      ArrayPosition2D position = ArrayPosition2D.argmax(
        TicTacToeModelService.qValuesMap!["${state["board"]}/${state["compSymbol"]}"],
      );
      _onMovePlaced(state["compSymbol"], position.row, position.col);
    } catch (e) {
      showSimpleGetSnackbar("Sorry. Try restarting the app.", 3);
    }
  }
}
