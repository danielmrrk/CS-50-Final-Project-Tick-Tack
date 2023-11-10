import 'package:flutter/material.dart';
import 'package:tic_tac/general/theme/color_theme.dart';

class Difficulty {
  Difficulty(
    this.displayName,
    this.time,
    this.technicalName,
    this.focused,
    this.difficultyPercentage,
    this.expRequiredForRankUp,
    this.color,
  );
  final String displayName;
  final String time;
  final String technicalName;
  bool focused;
  final int difficultyPercentage;
  final int expRequiredForRankUp;
  final Color color;

  static final drunkard = Difficulty(
    "Drunkard",
    "\u221E",
    "drunkard",
    false,
    50,
    30,
    TTColorTheme.drunkardHighlight,
  ); // unicode for ∞
  static final novice = Difficulty(
    "Novice",
    "10",
    "novice",
    false,
    50,
    40,
    TTColorTheme.noviceHighlight,
  );
  static final whiteKnight = Difficulty(
    "White Knight",
    "5",
    "white_knight",
    false,
    80,
    60,
    TTColorTheme.whiteKnightHighlight,
  );
  static final darkWizard = Difficulty(
    "Dark Wizard",
    "3",
    "dark_wizard",
    false,
    100,
    80,
    TTColorTheme.darkWizardHighlight,
  );

  static Difficulty fromDatabaseRank(String rank) {
    switch (rank) {
      case "Drunkard":
        return drunkard;
      case "Novice":
        return novice;
      case "White Knight":
        return whiteKnight;
      case "Dark Wizard":
        return darkWizard;
      default:
        return drunkard;
    }
  }

  static final ranks = [drunkard, novice, whiteKnight, darkWizard];
}
