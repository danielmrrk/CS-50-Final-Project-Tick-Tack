import 'package:flutter/material.dart';
import 'package:tic_tac/database/statistic/user_statistic.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';

class StatisticDisplay extends StatefulWidget {
  const StatisticDisplay({
    super.key,
    required this.displayValue,
    this.detailData,
    this.userData,
    this.imagePath,
    this.clickable = false,
  });

  final String displayValue;
  final UserStatistic? userData;
  final String? detailData;
  final String? imagePath;
  final bool clickable;

  @override
  State<StatisticDisplay> createState() => _StatisticDisplayState();
}

class _StatisticDisplayState extends State<StatisticDisplay> {
  bool _showMainContent = true;

  @override
  Widget build(BuildContext context) {
    return widget.clickable
        ? GestureDetector(
            onTap: () {
              setState(() {
                _showMainContent = !_showMainContent;
              });
            },
            child: _showMainContent ? buildMainContent() : buildDetailedContent(),
          )
        : buildMainContent();
  }

  Widget buildMainContent() => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: TTColorTheme.onBackground,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.imagePath != null) ...[
                Image.asset(widget.imagePath!),
                const Spacer(),
              ],
              Text(
                widget.displayValue,
                style: TTTextTheme.bodyStatisticDisplay(int.tryParse(widget.displayValue.replaceAll("%", "")) ?? 0),
              ),
            ],
          ),
        ),
      );

  Widget buildDetailedContent() => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: TTColorTheme.onBackgroundDark,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [displayDetailedContent() ?? const Text('No data')],
            )),
      );

  Widget? displayDetailedContent() {
    if (widget.detailData == null || widget.userData == null) {
      return null;
    }
    switch (widget.detailData) {
      case "win":
        return Column(
          children: [
            Row(
              children: [
                Text(
                  Difficulty.drunkard.displayName,
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
                const Spacer(),
                Text(
                  "${widget.userData!.winCountDrunkard}",
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  Difficulty.novice.displayName,
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
                const Spacer(),
                Text(
                  "${widget.userData!.winCountNovice}",
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  Difficulty.whiteKnight.displayName,
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
                const Spacer(),
                Text(
                  "${widget.userData!.winCountWhiteKnight}",
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  Difficulty.darkWizard.displayName,
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
                const Spacer(),
                Text(
                  "${widget.userData!.winCountDarkWizard}",
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
              ],
            ),
          ],
        );
      case "draw":
        return Column(
          children: [
            Row(
              children: [
                Text(
                  Difficulty.drunkard.displayName,
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
                const Spacer(),
                Text(
                  "${widget.userData!.drawCountDrunkard}",
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  Difficulty.novice.displayName,
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
                const Spacer(),
                Text(
                  "${widget.userData!.drawCountNovice}",
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  Difficulty.whiteKnight.displayName,
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
                const Spacer(),
                Text(
                  "${widget.userData!.drawCountWhiteKnight}",
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  Difficulty.darkWizard.displayName,
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
                const Spacer(),
                Text(
                  "${widget.userData!.drawCountDarkWizard}",
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
              ],
            ),
          ],
        );
      case "loss":
        return Column(
          children: [
            Row(
              children: [
                Text(
                  Difficulty.drunkard.displayName,
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
                const Spacer(),
                Text(
                  "${widget.userData!.lossCountDrunkard}",
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  Difficulty.novice.displayName,
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
                const Spacer(),
                Text(
                  "${widget.userData!.lossCountNovice}",
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  Difficulty.whiteKnight.displayName,
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
                const Spacer(),
                Text(
                  "${widget.userData!.lossCountWhiteKnight}",
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  Difficulty.darkWizard.displayName,
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
                const Spacer(),
                Text(
                  "${widget.userData!.lossCountDarkWizard}",
                  style: TTTextTheme.bodyMediumSemiBold,
                ),
              ],
            ),
          ],
        );
      default:
        return const Text('No data');
    }
  }
}
