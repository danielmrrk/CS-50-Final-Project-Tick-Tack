import 'package:flutter/material.dart';
import 'package:tic_tac/main_sceen/difficulty_item.dart';

class DifficultyGrid extends StatefulWidget {
  const DifficultyGrid({super.key});

  @override
  State<DifficultyGrid> createState() => _DifficultyGridState();
}

class _DifficultyGridState extends State<DifficultyGrid> {
  bool deactivatedStatus = false;
  bool isDarkened = false;
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
            deactivateSelection: deactivateSelection,
            deactivate: deactivatedStatus,
            isDarkened: isDarkened,
          ),
          DifficultyItem(
            rightSide: true,
            upSide: true,
            deactivateSelection: deactivateSelection,
            deactivate: deactivatedStatus,
            isDarkened: isDarkened,
          ),
          DifficultyItem(
            leftSide: true,
            downSide: true,
            deactivateSelection: deactivateSelection,
            deactivate: deactivatedStatus,
            isDarkened: isDarkened,
          ),
          DifficultyItem(
            rightSide: true,
            downSide: true,
            deactivateSelection: deactivateSelection,
            deactivate: deactivatedStatus,
            isDarkened: isDarkened,
          )
        ],
      ),
    );
  }

  void deactivateSelection(bool selected) {
    setState(() {
      deactivatedStatus = true;
      if (selected) {
        isDarkened = true;
      } else {
        isDarkened = false;
      }
    });
  }
}
