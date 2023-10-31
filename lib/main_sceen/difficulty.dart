class Difficulty {
  Difficulty(this.displayName, this.time, this.technicalName, this.focused);
  final String displayName;
  final String time;
  final String technicalName;
  bool focused;

  static final drunkard = Difficulty(
    "Drunkard",
    "\u221E",
    "drunkard",
    false,
  ); // unicode for ∞
  static final novice = Difficulty(
    "Novice",
    "10",
    "novice",
    false,
  );
  static final whiteKnight = Difficulty(
    "White Knight",
    "5",
    "white knight",
    false,
  );
  static final darkWizard = Difficulty(
    "Dark Wizard",
    "3",
    "dark wizard",
    false,
  );

  static final ranks = [drunkard, novice, whiteKnight, darkWizard];
}
