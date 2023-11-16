import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac/database/statistic/challenge.dart';
import 'package:tic_tac/database/statistic/statistic_database.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/statistic/challenge_item.dart';
import 'package:tic_tac/statistic/rank_display.dart';
import 'package:tic_tac/statistic/statistic_display.dart';
import 'package:tic_tac/statistic/user_statistic_service.dart';

class StatisticScreen extends ConsumerStatefulWidget {
  const StatisticScreen({super.key});
  @override
  StatisticScreenState createState() => StatisticScreenState();
}

class StatisticScreenState extends ConsumerState<StatisticScreen> {
  List<Challenge> _challenges = [];
  final key = GlobalKey<AnimatedListState>();
  @override
  void initState() {
    fetchChallenges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> userStatistic = ref.watch(userStatisticProvider);
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
                RankDisplay(userStatistic: userStatistic),
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
                        userStatistic: userStatistic,
                        imagePath: 'assets/images/trophy.png',
                        statisticKey: kWinKey,
                      ),
                      StatisticDisplay(
                        userStatistic: userStatistic,
                        imagePath: 'assets/images/balance-scale.png',
                        statisticKey: kDrawKey,
                      ),
                      StatisticDisplay(
                        userStatistic: userStatistic,
                        imagePath: 'assets/images/skull.png',
                        statisticKey: kLossKey,
                      ),
                      StatisticDisplay(
                        userStatistic: userStatistic,
                        imagePath: 'assets/images/trophy_skull.png',
                        statisticKey: kWinRate,
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
              child: _challenges.isNotEmpty
                  ? AnimatedList(
                      key: key,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      controller: controller,
                      initialItemCount: _challenges.length + 1,
                      itemBuilder: ((context, index, animation) {
                        return index == 0
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  "Mastery Challenges",
                                  style: TTTextTheme.strikingTitle,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ChallengeItem(
                                key: ValueKey(_challenges[index - 1].content),
                                challenge: _challenges[index - 1],
                                onRemoveClearedChallenge: () {
                                  onRemoveClearedChallenge(_challenges[index - 1], index, context);
                                },
                              );
                      }),
                    )
                  : SingleChildScrollView(
                      controller: controller,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Mastery Challenges",
                            style: TTTextTheme.strikingTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 44),
                        Text(
                          "You completed all challenges.\nCongratulations!",
                          style: TTTextTheme.bodyLargeSemiBold,
                          textAlign: TextAlign.center,
                        )
                      ]),
                    ),
            ),
          )
        ],
      ),
    );
  }

  void fetchChallenges() async {
    List<Challenge> challenges = await StatisticDatabase.instance.readAllShowableChallenges();
    setState(() {
      _challenges = challenges;
    });
  }

  void onRemoveClearedChallenge(Challenge challenge, int index, BuildContext context) async {
    bool rankUp = await ref.read(userStatisticProvider.notifier).maybeUpdateUserStatus(challenge);
    _challenges.removeAt(index - 1);
    print(_challenges.length);
    key.currentState!.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation.drive(
          Tween(begin: 0, end: 1),
        ),
        child: ChallengeItem(
          key: ValueKey(challenge.content),
          challenge: challenge,
          onRemoveClearedChallenge: () {
            onRemoveClearedChallenge(challenge, index, context);
          },
          setCleared: true,
        ),
      ),
      duration: const Duration(milliseconds: 500),
    );

    setState(() {
      if (rankUp) {
        fetchNewChallengeData();
      }
    });
    // TODO: fetch new challenges after rankup
  }

  fetchNewChallengeData() async {
    List<Challenge> challenges = await StatisticDatabase.instance.readAllShowableChallenges();
    int firstCaptionElement = 1;
    print(_challenges.length);
    int firstIndex = _challenges.length;
    List<Challenge> filteredChallenges = challenges.where((e) {
      for (var challenge in _challenges) {
        if (challenge.id == e.id) {
          return false;
        }
      }
      return true;
    }).toList();
    for (var challenge in filteredChallenges) {
      _challenges.insert(firstIndex, challenge);
      key.currentState!.insertItem(
        firstIndex + firstCaptionElement,
        duration: const Duration(milliseconds: 300),
      );
      firstIndex++;
    }
  }
}
