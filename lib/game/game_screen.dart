import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tic_tac/database/statistic/statistic_database.dart';

import 'package:tic_tac/game/game_field.dart';
import 'package:tic_tac/game/game_provider.dart';
import 'package:tic_tac/game/speech_bubble.dart';
import 'package:tic_tac/general/theme/button_theme.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/general/util/dialog.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';
import 'package:tic_tac/game/difficulty_card.dart';
import 'package:tic_tac/main_sceen/main_screen.dart';
import 'package:tic_tac/statistic/user_statistic_service.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key, required this.difficulty});

  final Difficulty difficulty;

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  int? _start;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _start = ref.watch(timeProvider);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DifficultyCard(
                  difficultyDisplay: widget.difficulty,
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
              difficultyDisplay: widget.difficulty,
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
                onTap: () {
                  CustomDialog.showGetDialog(
                      title: "Do you really want to give up?",
                      content: Container(
                        width: 272,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
                        child: Column(
                          children: [
                            const TTButton(title: "Yes").fullWidthButton(() {
                              ref.read(timeProvider.notifier).cancelTimer();
                              ref.read(userStatisticProvider.notifier).updateGameCount(
                                    widget.difficulty.displayName,
                                    kLossKey,
                                  );
                              Get.to(
                                () => const MainScreen(
                                  reset: true,
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            const TTButton(title: "No").fullWidthButton(() {
                              Get.back();
                            })
                          ],
                        ),
                      ),
                      closeable: true);
                },
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
}
