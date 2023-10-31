import 'package:flutter/material.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';
import 'package:tic_tac/main_sceen/difficulty_item.dart';

class DifficultyGrid extends StatefulWidget {
  const DifficultyGrid({super.key});

  @override
  State<DifficultyGrid> createState() => _DifficultyGridState();
}

class _DifficultyGridState extends State<DifficultyGrid> {
  bool _maybeDarken = false;
  Difficulty? _selectedDifficulty;
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
            leftSide: true,
            upSide: true,
            setFocus: setFocus,
            maybeDarken: _maybeDarken,
            difficultyDisplay: Difficulty.drunkard,
          ),
          DifficultyItem(
            rightSide: true,
            upSide: true,
            setFocus: setFocus,
            maybeDarken: _maybeDarken,
            difficultyDisplay: Difficulty.novice,
          ),
          DifficultyItem(
            leftSide: true,
            downSide: true,
            setFocus: setFocus,
            maybeDarken: _maybeDarken,
            difficultyDisplay: Difficulty.whiteKnight,
          ),
          DifficultyItem(
            rightSide: true,
            downSide: true,
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
          _selectedDifficulty = rank.focused ? rank : null;
        } else {
          rank.focused = false;
        }
      }
    });
  }
}
