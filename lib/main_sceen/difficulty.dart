class Difficulty {
  Difficulty(
    this.displayName,
    this.time,
    this.technicalName,
    this.focused,
    this.difficultyPercentage,
    this.expRequiredForRankUp,
  );
  final String displayName;
  final String time;
  final String technicalName;
  bool focused;
  final int difficultyPercentage;
  final int expRequiredForRankUp;

  static final drunkard = Difficulty(
    "Drunkard",
    "\u221E",
    "drunkard",
    false,
    50,
    30,
  ); // unicode for ∞
  static final novice = Difficulty(
    "Novice",
    "10",
    "novice",
    false,
    50,
    40,
  );
  static final whiteKnight = Difficulty(
    "White Knight",
    "5",
    "white_knight",
    false,
    80,
    60,
  );
  static final darkWizard = Difficulty(
    "Dark Wizard",
    "3",
    "dark_wizard",
    false,
    100,
    80,
  );

  static final ranks = [drunkard, novice, whiteKnight, darkWizard];
}
