import 'package:flutter/material.dart';
import 'package:tic_tac/game/difficulty_card.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';
import 'package:tic_tac/statistic/exp_progress_bar.dart';
import 'package:tic_tac/statistic/user_statistic_service.dart';

class RankDisplay extends StatelessWidget {
  const RankDisplay({super.key, required this.userStatistic});
  final double strokeHeight = 4;
  final Map<String, String> userStatistic;

  @override
  Widget build(BuildContext context) {
    Difficulty difficulty = Difficulty.fromStorage(userStatistic[kRankKey] ?? "Drunkard");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "RANK",
                style: TTTextTheme.bodyLargeSemiBold,
              ),
              const SizedBox(height: 12),
              Text(
                difficulty.displayName,
                style: TTTextTheme.colorfulTitle,
              )
            ],
          ),
        ),
        Stack(
          children: [
            DifficultyCard(
              difficultyDisplay: difficulty,
              strokeColor: Colors.white,
              height: 180,
              width: 208,
              rankImage: true,
            ),
            Positioned(
              left: strokeHeight,
              bottom: strokeHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 28,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: difficulty.secondaryColor.withOpacity(0.8),
                    ),
                  ),
                  Positioned(
                      left: 0, bottom: 0, child: ExpProgresBar(difficulty: difficulty, exp: int.tryParse(userStatistic[kExpKey]!) ?? 0)),
                  Text(
                    difficulty == Difficulty.darkWizard &&
                            int.tryParse(userStatistic[kExpKey] ?? '0') == Difficulty.darkWizard.expRequiredForRankUp
                        ? "MAXED OUT"
                        : "${userStatistic[kExpKey] ?? '0'} / "
                            "${difficulty.expRequiredForRankUp}",
                    style: TTTextTheme.bodyMedium,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
