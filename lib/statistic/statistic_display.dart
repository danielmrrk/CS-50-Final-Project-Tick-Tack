import 'package:flutter/material.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';

class StatisticDisplay extends StatefulWidget {
  const StatisticDisplay({
    super.key,
    required this.userStatistic,
    required this.statisticKey,
    this.imagePath,
  });

  final Map<String, String> userStatistic;
  final String statisticKey;
  final String? imagePath;

  @override
  State<StatisticDisplay> createState() => _StatisticDisplayState();
}

class _StatisticDisplayState extends State<StatisticDisplay> {
  bool _showMainContent = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showMainContent = !_showMainContent;
        });
      },
      child: _showMainContent ? buildMainContent() : buildDetailedContent(),
    );
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
                widget.userStatistic[widget.statisticKey]!,
                style: TTTextTheme.bodyStatisticDisplay(int.tryParse(widget.userStatistic[widget.statisticKey]!.replaceAll("%", ""))!),
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
        child: Padding(padding: const EdgeInsets.all(16), child: displayDetailedContent(widget.statisticKey)),
      );

  Widget displayDetailedContent(String userStatisticKey) {
    return Column(
      children: [
        for (var rank in Difficulty.ranks)
          Row(
            children: [
              Text(
                rank.displayName,
                style: TTTextTheme.bodySmallSemiBold,
              ),
              const Spacer(),
              Text(
                widget.userStatistic["$userStatisticKey/${rank.displayName}"] != null
                    ? widget.userStatistic["$userStatisticKey/${rank.displayName}"]!
                    : '0',
                style: TTTextTheme.bodySmallSemiBold,
              ),
            ],
          ),
      ],
    );
  }
}
