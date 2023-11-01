import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tic_tac/general/theme/color_theme.dart';

class GameField extends StatefulWidget {
  const GameField({super.key, required this.resetTimer, required this.cancelTimer});

  final Function resetTimer;
  final Function cancelTimer;

  @override
  State<GameField> createState() => _GameFieldState();
}

class _GameFieldState extends State<GameField> {
  final List<List<String>> _board = List.generate(3, (index) => List.generate(3, (index) => ""));
  String _currentPlayer = "X";
  int moves = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              moves++;
              List<List<String>> board = _board;
              String currentPlayer = _currentPlayer;
              _onMovePlaced(row, col);
              if (_checkWin(board, currentPlayer)) {
                widget.cancelTimer();
                print("Won");
              } else if (moves == 9) {
                widget.cancelTimer();
                print("Draw");
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              color: TTColorTheme.background,
              child: _board[row][col] != ""
                  ? SvgPicture.asset(
                      "assets/${_board[row][col]}.svg",
                    )
                  : null,
            ),
          );
        }),
      ),
    );
  }

  void _onMovePlaced(int row, int col) {
    if (_board[row][col] != "") {
      return;
    }
    setState(() {
      _board[row][col] = _currentPlayer;
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
}
