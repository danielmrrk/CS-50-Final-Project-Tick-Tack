import 'package:flutter/material.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/main_sceen/conversation_data.dart';

class Difficulty {
  Difficulty(
    this.displayName,
    this.time,
    this.technicalName,
    this.focused,
    this.difficultyPercentage,
    this.expRequiredForRankUp,
    this.primaryColor,
    this.secondaryColor,
    this.conversationData,
  );
  final String displayName;
  final String time;
  final String technicalName;
  bool focused;
  final int difficultyPercentage;
  final int expRequiredForRankUp;
  final Color primaryColor;
  final Color secondaryColor;
  final List<String> conversationData;

  static final drunkard = Difficulty(
    "Drunkard",
    "\u221E",
    "drunkard",
    false,
    50,
    30,
    TTColorTheme.drunkardPrimary,
    TTColorTheme.drunkardSecondary,
    drunkardConversation,
  ); // unicode for ∞
  static final novice =
      Difficulty("Novice", "10", "novice", false, 50, 40, TTColorTheme.novicePrimary, TTColorTheme.noviceSecondary, noviceConversation);
  static final whiteKnight = Difficulty(
    "White Knight",
    "5",
    "white_knight",
    false,
    50,
    60,
    TTColorTheme.whiteKnightPrimary,
    TTColorTheme.whiteKnightSecondary,
    whiteKnightConversation,
  );
  static final darkWizard = Difficulty(
    "Dark Wizard",
    "3",
    "dark_wizard",
    false,
    50,
    80,
    TTColorTheme.darkWizardPrimary,
    TTColorTheme.darkWizardSecondary,
    darkWizardConversation,
  );

  static Difficulty fromStorage(String rank) {
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

  static final ranks = [
    drunkard,
    novice,
    whiteKnight,
    darkWizard,
  ];
}
