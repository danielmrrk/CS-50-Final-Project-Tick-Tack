class Difficulty {
  Difficulty(this.displayName, this.time, this.technicalName, this.focused, this.difficultyPercentage);
  final String displayName;
  final String time;
  final String technicalName;
  bool focused;
  final int difficultyPercentage;

  static final drunkard = Difficulty(
    "Drunkard",
    "\u221E",
    "drunkard",
    false,
    50,
  ); // unicode for ∞
  static final novice = Difficulty(
    "Novice",
    "10",
    "novice",
    false,
    50,
  );
  static final whiteKnight = Difficulty(
    "White Knight",
    "5",
    "white knight",
    false,
    80,
  );
  static final darkWizard = Difficulty(
    "Dark Wizard",
    "3",
    "dark wizard",
    false,
    95,
  );

  static final ranks = [drunkard, novice, whiteKnight, darkWizard];
}
