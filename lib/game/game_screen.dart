import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tic_tac/game/speech_bubble.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';
import 'package:tic_tac/main_sceen/difficulty_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.difficultyDisplay});

  final Difficulty difficultyDisplay;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SimpleDifficultyCard(
                  difficultyDisplay: widget.difficultyDisplay,
                  strokeColor: TTColorTheme.onBackground,
                  height: 180,
                  width: 164,
                ),
                const SizedBox(width: 24),
                const SpeechBubble(dialogue: "Who dares to challenge me. Bring it on!"),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(44),
              child: Container(
                color: TTColorTheme.onBackground,
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  clipBehavior: Clip.hardEdge,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    9,
                    (index) => GestureDetector(
                      onTap: () {},
                      child: Container(
                        color: TTColorTheme.background,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
