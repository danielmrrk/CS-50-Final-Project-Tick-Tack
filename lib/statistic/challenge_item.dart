import 'package:flutter/material.dart';
import 'package:tic_tac/database/statistic/challenge.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';

class ChallengeItem extends StatelessWidget {
  const ChallengeItem({super.key, required this.challengeData});

  final Challenge challengeData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 2),
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: TTColorTheme.background,
          border: Border.all(color: TTColorTheme.secondary, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(challengeData.content, style: TTTextTheme.bodyMediumSemiBold),
            ),
            Text("+ ${challengeData.exp} EXP", style: TTTextTheme.expDisplay)
          ],
        ),
      ),
    );
  }
}
