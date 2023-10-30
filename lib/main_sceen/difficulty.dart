class Difficulty {
  const Difficulty(this.displayName, this.time, this.technicalName);
  final String displayName;
  final String time;
  final String technicalName;

  static const drunkard = Difficulty("Drunkard", "infinity", "drunkard");
  static const novice = Difficulty("Novice", "10", "novice");
  static const whiteKnight = Difficulty("White Knight", "5", "white knight");
  static const darkWizard = Difficulty("Dark Wizard", "3", "dark wizard");
}
