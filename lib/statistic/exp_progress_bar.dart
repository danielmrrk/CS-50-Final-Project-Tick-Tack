import 'package:flutter/material.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';

class ExpProgresBar extends StatelessWidget {
  const ExpProgresBar({
    super.key,
    required this.difficulty,
    required this.exp,
  });

  final Difficulty difficulty;
  final int exp;

  @override
  Widget build(BuildContext context) {
    double expWidth = 200 * (exp / difficulty.expRequiredForRankUp);
    return Container(
      alignment: Alignment.centerLeft,
      height: 28,
      width: expWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: difficulty.primaryColor.withOpacity(0.9),
      ),
    );
  }
}
