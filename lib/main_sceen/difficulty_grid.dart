import 'package:flutter/material.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';
import 'package:tic_tac/main_sceen/difficulty_item.dart';

class DifficultyGrid extends StatefulWidget {
  const DifficultyGrid({super.key, required this.setSelectedDifficulty});

  final Function(Difficulty rank) setSelectedDifficulty;

  @override
  State<DifficultyGrid> createState() => _DifficultyGridState();
}

class _DifficultyGridState extends State<DifficultyGrid> {
  bool _maybeDarken = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        childAspectRatio: 164 / 188,
        children: [
          DifficultyItem(
            setFocus: setFocus,
            maybeDarken: _maybeDarken,
            difficultyDisplay: Difficulty.drunkard,
          ),
          DifficultyItem(
            setFocus: setFocus,
            maybeDarken: _maybeDarken,
            difficultyDisplay: Difficulty.novice,
          ),
          DifficultyItem(
            setFocus: setFocus,
            maybeDarken: _maybeDarken,
            difficultyDisplay: Difficulty.whiteKnight,
          ),
          DifficultyItem(
            setFocus: setFocus,
            maybeDarken: _maybeDarken,
            difficultyDisplay: Difficulty.darkWizard,
          )
        ],
      ),
    );
  }

  void setFocus(String difficultyName) {
    setState(() {
      for (Difficulty rank in Difficulty.ranks) {
        if (rank.displayName == difficultyName) {
          rank.focused = !rank.focused;
          _maybeDarken = rank.focused;
          widget.setSelectedDifficulty(rank);
        } else {
          rank.focused = false;
        }
      }
    });
  }
}
