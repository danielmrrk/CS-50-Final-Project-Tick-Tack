import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tic_tac/general/theme/button_theme.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/util/array_position_2d.dart';
import 'package:tic_tac/general/util/dialog.dart';
import 'package:tic_tac/general/util/navigation.dart';
import 'package:tic_tac/main_sceen/main_screen.dart';

class GameField extends StatefulWidget {
  const GameField({super.key, required this.resetTimer, required this.cancelTimer});

  final Function resetTimer;
  final Function cancelTimer;

  @override
  State<GameField> createState() => _GameFieldState();
}

class _GameFieldState extends State<GameField> {
  final List<List<String>> _board = List.generate(3, (index) => List.generate(3, (index) => "' '"));
  String _currentPlayer = "X";
  final String _playerSymbol = "X";
  final String _computerSymbol = "O";
  int _moves = 0;
  bool _isOver = false;
  late Map<String, dynamic> _qValuesMap;

  @override
  void initState() {
    _loadQValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget dialogContent = Container(
      width: 272,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
      child: Column(
        children: [
          const TTButton(title: "New Game").fullWidthButton(() {
            navigateTo(
                const MainScreen(
                  reset: true,
                ),
                context);
          }),
          const SizedBox(height: 8),
          const TTButton(title: "Statistics").fullWidthButton(() {})
        ],
      ),
    );
    return Container(
      margin: const EdgeInsets.fromLTRB(48, 44, 48, 14),
      color: TTColorTheme.onBackground,
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(9, (index) {
          int row = index ~/ 3;
          int col = index % 3;
          return GestureDetector(
            onTap: () {
              if (!_isOver) {
                _moves++;
                List<List<String>> board = _board;
                String currentPlayer = _currentPlayer;
                if (currentPlayer == _playerSymbol) {
                  _onMovePlaced(row, col);
                } else {
                  _movePlacedByComp();
                }
                if (_moves >= 3) {
                  if (_checkWin(board, currentPlayer)) {
                    widget.cancelTimer();
                    _isOver = true;
                    showGetDialog(
                      currentPlayer == _playerSymbol
                          ? "Triumph is yours. A well deserved victory!"
                          : "What an unfortunate loss. Good luck next time!",
                      dialogContent,
                      context,
                    );
                  } else if (_moves == 9) {
                    widget.cancelTimer();
                    showGetDialog(
                      "Getting a draw is sometimes the best!",
                      dialogContent,
                      context,
                    );
                    _isOver = true;
                  }
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              color: TTColorTheme.background,
              child: _board[row][col] != "' '"
                  ? SvgPicture.asset(
                      "assets/images/$_currentPlayer.svg",
                    )
                  : null,
            ),
          );
        }),
      ),
    );
  }

  void _onMovePlaced(int row, int col) {
    if (_board[row][col] != "' '") {
      return;
    }
    setState(() {
      _board[row][col] = "'$_currentPlayer'";
      _currentPlayer = _currentPlayer == "X" ? "O" : "X";
    });
    widget.resetTimer();
  }

  bool _checkWin(List<List<String>> board, String currentPlayer) {
    for (List<String> row in board) {
      if (row.every((cell) => cell == currentPlayer)) {
        return true;
      }
    }
    for (int col = 0; col < 3; col++) {
      if (board.every((row) => row[col] == currentPlayer)) {
        return true;
      }
    }
    if ([0, 1, 2].every((i) => board[i][i] == currentPlayer) ||
        [0, 1, 2].every(
          (j) => board[2 - j][j] == currentPlayer,
        )) {
      return true;
    }
    return false;
  }

  Future<void> _loadQValues() async {
    final Map<String, dynamic> qValuesMap = json.decode(await rootBundle.loadString("assets/q_values.json"));
    setState(() {
      _qValuesMap = qValuesMap;
    });
  }

  void _movePlacedByComp() {
    // now compSymbol always the same later more specific!!!
    String key = "$_board/$_computerSymbol";
    print(_qValuesMap.keys.last);
    print("key: $key");
    print(_qValuesMap.values.first);
    //ArrayPosition2D position = _argmax(_qValuesMap["$_board/$_computerSymbol"]);
    //_onMovePlaced(position.row, position.col);
  }

  ArrayPosition2D _argmax(List<List<double>> qValues) {
    int row = 0;
    int col = 0;
    double maxValue = qValues[row][col];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (qValues[row][col] > maxValue) {
          row = i;
          col = j;
          maxValue = qValues[i][j];
        }
      }
    }
    return ArrayPosition2D(row: row, col: col);
  }
}
