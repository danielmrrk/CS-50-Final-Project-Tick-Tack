import 'package:flutter/material.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';

class StatisticDisplay extends StatelessWidget {
  const StatisticDisplay({super.key, required this.displayValue, this.imagePath});

  final String displayValue;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: TTColorTheme.onBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null) ...[
              Image.asset(imagePath!),
              const Spacer(),
            ],
            Text(
              displayValue,
              style: TTTextTheme.bodyStatisticDisplay(int.tryParse(displayValue.replaceAll("%", "")) ?? 0),
            ),
          ],
        ),
      ),
    );
  }
}
