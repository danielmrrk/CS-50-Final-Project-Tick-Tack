import 'package:flutter/material.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';

class StatisticDisplay extends StatelessWidget {
  const StatisticDisplay({super.key, required this.displayValue});

  final String displayValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: TTColorTheme.onBackground,
      child: Center(
        child: Text(
          displayValue,
          style: TTTextTheme.bodyStatisticDisplay,
        ),
      ),
    );
  }
}
