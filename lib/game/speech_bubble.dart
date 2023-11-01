import 'package:flutter/material.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/general/theme/util/triangle.dart';

class SpeechBubble extends StatelessWidget {
  const SpeechBubble({super.key, required this.dialogue});

  final String dialogue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          // TODO: dynamic!!!
          padding: EdgeInsets.only(bottom: 64),
          child: CustomPaint(
            painter: Triangle(color: TTColorTheme.onBackground, scale: 1),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: TTColorTheme.onBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          width: 204,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Text(
              dialogue,
              style: TTTextTheme.bodyLargeSemiBold,
              textAlign: TextAlign.left,
            ),
          ),
        )
      ],
    );
  }
}
