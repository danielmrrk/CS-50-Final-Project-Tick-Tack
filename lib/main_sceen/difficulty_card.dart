import 'package:flutter/material.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';

class SimpleDifficultyCard extends StatelessWidget {
  const SimpleDifficultyCard({
    super.key,
    required this.difficultyDisplay,
    required this.strokeColor,
    required this.height,
    required this.width,
  });

  final Difficulty difficultyDisplay;
  final Color strokeColor;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: strokeColor, width: 4, strokeAlign: -1),
        ),
        child: Image(
          image: AssetImage("assets/images/edited_${difficultyDisplay.technicalName}.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
