import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tic_tac/game/game_field.dart';
import 'package:tic_tac/game/speech_bubble.dart';
import 'package:tic_tac/general/theme/button_theme.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/general/util/dialog.dart';
import 'package:tic_tac/general/util/navigation.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';
import 'package:tic_tac/main_sceen/difficulty_card.dart';
import 'package:tic_tac/main_sceen/main_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.difficultyDisplay});

  final Difficulty difficultyDisplay;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int? _start;
  Timer? _timer;

  @override
  void initState() {
    _start = int.tryParse(widget.difficultyDisplay.time);
    if (_start != null) {
      _startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
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
            child: GameField(
              resetTimer: _resetTimer,
              cancelTimer: _cancelTimer,
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 60,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                  color: TTColorTheme.onBackground,
                ),
                alignment: Alignment.center,
                child: _start != null
                    ? Text(
                        _start != 10 ? "00:0$_start" : "00:$_start",
                        style: TTTextTheme.bodyExtraLarge,
                      )
                    : Text(
                        "No Limit",
                        style: TTTextTheme.bodyLarge,
                      ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 60,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                    color: TTColorTheme.onBackground,
                  ),
                  child: SvgPicture.asset("assets/images/white_flag.svg"),
                ),
                onTap: () {},
              )
            ],
          ),
          const SizedBox(
            height: 90,
          )
        ],
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == null) {
        throw Exception("The starter value shouldn't be null");
      }
      setState(() {
        if (_start! > 1) {
          _start = _start! - 1;
        } else {
          _start = _start! - 1;
          showGetDialog(
              "You lost on time. Good luck next time.",
              Container(
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
              ),
              context);
          timer.cancel();
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _start = int.tryParse(widget.difficultyDisplay.time);
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }
}
