import 'package:flutter/material.dart';
import 'package:tic_tac/database/statistic/challenge.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/statistic/user_statistic_service.dart';

class ChallengeItem extends StatelessWidget {
  const ChallengeItem({super.key, required this.challengeData});

  final Challenge challengeData;

  @override
  Widget build(BuildContext context) {
    bool cleared = challengeData.cleared && challengeData.showChallenge;
    return InkWell(
      onTap: () {
        if (cleared) UserStatisticService.instance.maybeUpdateUserStatus(challengeData.exp);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 2),
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cleared ? TTColorTheme.onBackgroundDark : TTColorTheme.background,
          border: Border.all(color: TTColorTheme.secondary, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: challengeData.progress != null
                  ? RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: challengeData.content, style: TTTextTheme.bodyMediumSemiBold),
                          TextSpan(
                            text: " (${challengeData.progress}/${challengeData.progressGoal})",
                            style: TTTextTheme.bodyMediumBold,
                          ),
                        ],
                      ),
                    )
                  : Text(challengeData.content, style: TTTextTheme.bodyMediumSemiBold),
            ),
            Text(
              "+ ${challengeData.exp} EXP",
              style: TTTextTheme.expDisplay(cleared),
            )
          ],
        ),
      ),
    );
  }
}
