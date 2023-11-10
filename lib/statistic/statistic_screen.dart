import 'package:flutter/material.dart';
import 'package:tic_tac/database/statistic/statistic_database.dart';
import 'package:tic_tac/database/statistic/user_statistic.dart';
import 'package:tic_tac/statistic/rank_display.dart';
import 'package:tic_tac/statistic/statistic_display.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});
  @override
  StatisticScreenState createState() => StatisticScreenState();
}

class StatisticScreenState extends State<StatisticScreen> {
  UserStatistic? _userStatistic;
  @override
  void initState() {
    initUserStatistic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistic'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Column(
          children: [
            RankDisplay(userStatistic: _userStatistic),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                childAspectRatio: 1.6,
                crossAxisCount: 2,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  StatisticDisplay(displayValue: _userStatistic?.winCount.toString() ?? '0'),
                  StatisticDisplay(displayValue: _userStatistic?.drawCount.toString() ?? '0'),
                  StatisticDisplay(displayValue: _userStatistic?.lossCount.toString() ?? '0'),
                  StatisticDisplay(displayValue: _userStatistic?.winRate.toString() ?? '0'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void initUserStatistic() async {
    UserStatistic userStatistic = await StatisticDatabase.instance.readUserStatistic();
    setState(() {
      _userStatistic = userStatistic;
    });
  }
}
