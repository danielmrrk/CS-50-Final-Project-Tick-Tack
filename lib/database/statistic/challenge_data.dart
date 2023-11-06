import 'package:tic_tac/database/statistic/challenge.dart';

enum ClearCondition {
  winDrunkard,
  winNovice,
  winWhiteKnight,
  winDarkWizard,
  drawDarkWizard,
  winWithoutLosingWhiteKnight,
  winWithoutLosingDarkWizard,
  win,
}

enum DifficultyRank {
  drunkard,
  novice,
  whiteKnight,
  darkWizard,
}

final challengeData = [
  Challenge(
    content: "Win against drunkard 3 times",
    progress: 0,
    progressGoal: 3,
    exp: 15,
    difficulty: DifficultyRank.drunkard.toString(),
    showChallenge: true,
    clearCondition: ClearCondition.winDrunkard.toString(),
  ),
  Challenge(
    content: "Defeat the young novice.",
    exp: 10,
    difficulty: DifficultyRank.drunkard.toString(),
    showChallenge: true,
    clearCondition: ClearCondition.winNovice.toString(),
  ),
  Challenge(
    content: "Win against the white knight once.",
    exp: 20,
    difficulty: DifficultyRank.drunkard.toString(),
    showChallenge: true,
    clearCondition: ClearCondition.winWhiteKnight.toString(),
  ),
  Challenge(
    content: "Win against the almighty dark wizard.",
    exp: 30,
    difficulty: DifficultyRank.drunkard.toString(),
    showChallenge: true,
    clearCondition: ClearCondition.winDarkWizard.toString(),
  ),
  Challenge(
    content: "Win against white knight 5 times.",
    progress: 0,
    progressGoal: 5,
    exp: 50,
    difficulty: DifficultyRank.novice.toString(),
    clearCondition: ClearCondition.winWhiteKnight.toString(),
  ),
  Challenge(
    content: "Win in 3 moves",
    exp: 5,
    difficulty: DifficultyRank.novice.toString(),
    clearCondition: ClearCondition.win.toString(),
  ),
  Challenge(
    content: "Achieve a draw against the dark wizard.",
    exp: 5,
    difficulty: DifficultyRank.whiteKnight.toString(),
    clearCondition: ClearCondition.drawDarkWizard.toString(),
  ),
  Challenge(
    content: "Win 3 times against white knight without loosing once inbetween.",
    progress: 0,
    progressGoal: 3,
    exp: 25,
    difficulty: DifficultyRank.darkWizard.toString(),
    clearCondition: ClearCondition.winWithoutLosingWhiteKnight.toString(),
  ),
  Challenge(
    content: "Win 2 times against the dark wizard without loosing once inbetween.",
    progress: 0,
    progressGoal: 2,
    exp: 50,
    difficulty: DifficultyRank.darkWizard.toString(),
    clearCondition: ClearCondition.winWithoutLosingDarkWizard.toString(),
  ),
];
