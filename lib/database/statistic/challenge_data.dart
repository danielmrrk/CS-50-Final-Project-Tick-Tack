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
    id: 0,
    content: "Win against drunkard 3 times",
    progress: 0,
    progressGoal: 3,
    exp: 15,
    difficulty: DifficultyRank.drunkard.toString(),
    showChallenge: true,
    clearCondition: ClearCondition.winDrunkard.toString(),
  ),
  Challenge(
    id: 1,
    content: "Defeat the young novice",
    exp: 10,
    difficulty: DifficultyRank.drunkard.toString(),
    showChallenge: true,
    clearCondition: ClearCondition.winNovice.toString(),
  ),
  Challenge(
    id: 2,
    content: "Win against the white knight once",
    exp: 20,
    difficulty: DifficultyRank.drunkard.toString(),
    showChallenge: true,
    clearCondition: ClearCondition.winWhiteKnight.toString(),
  ),
  Challenge(
    id: 3,
    content: "Win against the almighty dark wizard",
    exp: 30,
    difficulty: DifficultyRank.drunkard.toString(),
    showChallenge: true,
    clearCondition: ClearCondition.winDarkWizard.toString(),
  ),
  Challenge(
    id: 4,
    content: "Win against white knight 5 times",
    progress: 0,
    progressGoal: 5,
    exp: 50,
    difficulty: DifficultyRank.novice.toString(),
    clearCondition: ClearCondition.winWhiteKnight.toString(),
  ),
  Challenge(
    id: 5,
    content: "Win in 3 moves",
    exp: 5,
    difficulty: DifficultyRank.novice.toString(),
    clearCondition: ClearCondition.win.toString(),
  ),
  Challenge(
    id: 6,
    content: "Achieve a draw against the dark wizard",
    exp: 5,
    difficulty: DifficultyRank.whiteKnight.toString(),
    clearCondition: ClearCondition.drawDarkWizard.toString(),
  ),
  Challenge(
    id: 7,
    content: "Win 3 times against white knight without loosing once inbetween",
    progress: 0,
    progressGoal: 3,
    exp: 25,
    difficulty: DifficultyRank.darkWizard.toString(),
    clearCondition: ClearCondition.winWithoutLosingWhiteKnight.toString(),
  ),
  Challenge(
    id: 8,
    content: "Win 2 times against the dark wizard without loosing once inbetween",
    progress: 0,
    progressGoal: 2,
    exp: 50,
    difficulty: DifficultyRank.darkWizard.toString(),
    clearCondition: ClearCondition.winWithoutLosingDarkWizard.toString(),
  ),
];
