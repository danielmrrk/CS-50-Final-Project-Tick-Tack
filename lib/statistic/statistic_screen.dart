import 'package:flutter/material.dart';
import 'package:tic_tac/database/statistic/challenge.dart';
import 'package:tic_tac/database/statistic/statistic_database.dart';
import 'package:tic_tac/database/statistic/user_statistic.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/statistic/challenge_item.dart';
import 'package:tic_tac/statistic/rank_display.dart';
import 'package:tic_tac/statistic/statistic_display.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});
  @override
  StatisticScreenState createState() => StatisticScreenState();
}

class StatisticScreenState extends State<StatisticScreen> {
  UserStatistic? _userStatistic;
  List<Challenge> _challenges = [];
  @override
  void initState() {
    initUserStatistic();
    initChallenges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistic'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                      StatisticDisplay(
                        userData: _userStatistic,
                        displayValue: _userStatistic?.winCount.toString() ?? '0',
                        imagePath: 'assets/images/trophy.png',
                        detailData: "win",
                        clickable: true,
                      ),
                      StatisticDisplay(
                        userData: _userStatistic,
                        displayValue: _userStatistic?.drawCount.toString() ?? '0',
                        imagePath: 'assets/images/balance-scale.png',
                        detailData: "draw",
                        clickable: true,
                      ),
                      StatisticDisplay(
                        userData: _userStatistic,
                        displayValue: _userStatistic?.lossCount.toString() ?? '0',
                        imagePath: 'assets/images/skull.png',
                        detailData: "loss",
                        clickable: true,
                      ),
                      StatisticDisplay(
                        displayValue: "${_userStatistic?.winRate.toString() ?? '0'}%",
                        imagePath: 'assets/images/trophy_skull.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.7,
            snap: true,
            builder: (context, controller) => Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                gradient: LinearGradient(
                  colors: [Color(0xff3e1277), Color(0xff4d1e8b)],
                  stops: [0, 0.7],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                controller: controller,
                itemCount: _challenges.length + 1,
                itemBuilder: ((context, index) {
                  return index == 0
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Mastery Challenges",
                            style: TTTextTheme.strikingTitle,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ChallengeItem(challengeData: _challenges[index - 1]);
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  void initUserStatistic() async {
    UserStatistic userStatistic = await StatisticDatabase.instance.readUserStatistic();
    setState(() {
      _userStatistic = userStatistic;
    });
  }

  void initChallenges() async {
    List<Challenge> challenges = await StatisticDatabase.instance.readAllShowableChallenges();
    setState(() {
      _challenges = challenges;
    });
  }
}
