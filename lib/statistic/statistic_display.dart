import 'package:flutter/material.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';
import 'package:tic_tac/statistic/user_statistic_service.dart';

class StatisticDisplay extends StatefulWidget {
  const StatisticDisplay({
    super.key,
    required this.displayValue,
    this.detailData,
    this.userStatistic,
    this.imagePath,
    this.clickable = false,
  });

  final String displayValue;
  final Map<String, String>? userStatistic;
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
              children: [displayDetailedContent(widget.detailData!)],
            )),
      );

  Widget displayDetailedContent(String gameResultKey) {
    switch (gameResultKey) {
      case kWinKey:
        return getSpecificResultColumn(kWinKey);
      case kDrawKey:
        return getSpecificResultColumn(kDrawKey);
      case kLossKey:
        return getSpecificResultColumn(kLossKey);
      default:
        throw Exception("Invalid game result key");
    }
  }

  Widget getSpecificResultColumn(String gameResultKey) {
    return Column(
      children: [
        for (var rank in Difficulty.ranks)
          Row(
            children: [
              Text(
                rank.displayName,
                style: TTTextTheme.bodyMediumSemiBold,
              ),
              const Spacer(),
              Text(
                widget.userStatistic?["$gameResultKey/${rank.displayName}"] ?? '0',
                style: TTTextTheme.bodyMediumSemiBold,
              ),
            ],
          ),
      ],
    );
  }
}
