import 'package:flutter/material.dart';
import 'package:tic_tac/database/statistic/challenge.dart';
import 'package:tic_tac/database/statistic/statistic_database.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';

class ChallengeItem extends StatelessWidget {
  const ChallengeItem({
    super.key,
    required this.challenge,
    required this.onRemoveClearedChallenge,
  });

  final Challenge challenge;
  final Function onRemoveClearedChallenge;

  @override
  Widget build(BuildContext context) {
    bool cleared = challenge.cleared && challenge.showChallenge;
    return InkWell(
      onTap: () {
        if (cleared) {
          onRemoveClearedChallenge();
          StatisticDatabase.instance.onCollectUpdateChallenge(challenge);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cleared ? TTColorTheme.secondary : TTColorTheme.background,
          border: Border.all(color: TTColorTheme.secondaryStroke, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: challenge.progress != null
                  ? RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: challenge.content, style: TTTextTheme.bodyMediumSemiBold),
                          TextSpan(
                            text: " (${challenge.progress}/${challenge.progressGoal})",
                            style: TTTextTheme.bodyMediumBold,
                          ),
                        ],
                      ),
                    )
                  : Text(challenge.content, style: TTTextTheme.bodyMediumSemiBold),
            ),
            Text(
              "+ ${challenge.exp} EXP",
              style: TTTextTheme.expDisplay(cleared),
            )
          ],
        ),
      ),
    );
  }
}
