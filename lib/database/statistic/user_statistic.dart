import 'package:tic_tac/database/statistic/statistic_database.dart';

const userStatisticTable = 'user_statistic';

class UserStatisticField {
  final List<String> values = [
    winCountDrunkard,
    winCountNovice,
    winCountWhiteKnight,
    winCountDarkWizard,
    drawCountDrunkard,
    drawCountNovice,
    drawCountWhiteKnight,
    drawCountDarkWizard,
    lossCountDrunkard,
    lossCountNovice,
    lossCountWhiteKnight,
    lossCountDarkWizard,
    rank,
    rankExp,
  ];
  static const winCountDrunkard = 'win_count_drunkard';
  static const winCountNovice = 'win_count_novice';
  static const winCountWhiteKnight = 'win_count_white_knight';
  static const winCountDarkWizard = 'win_count_dark_wizard';

  static const drawCountDrunkard = 'draw_count_drunkard';
  static const drawCountNovice = 'draw_count_novice';
  static const drawCountWhiteKnight = 'draw_count_white_knight';
  static const drawCountDarkWizard = 'draw_count_dark_wizard';

  static const lossCountDrunkard = 'loss_count_drunkard';
  static const lossCountNovice = 'loss_count_novice';
  static const lossCountWhiteKnight = 'loss_count_white_knight';
  static const lossCountDarkWizard = 'loss_count_dark_wizard';

  static const rank = 'rank';
  static const rankExp = 'rank_exp';
}

class UserStatistic {
  final int winCountDrunkard;
  final int winCountNovice;
  final int winCountWhiteKnight;
  final int winCountDarkWizard;
  final int drawCountDrunkard;
  final int drawCountNovice;
  final int drawCountWhiteKnight;
  final int drawCountDarkWizard;
  final int lossCountDrunkard;
  final int lossCountNovice;
  final int lossCountWhiteKnight;
  final int lossCountDarkWizard;
  final String rank;
  final int rankExp;
  final int winCount;
  final int drawCount;
  final int lossCount;
  final int winRate;

  UserStatistic({
    this.winCountDrunkard = 0,
    this.winCountNovice = 0,
    this.winCountWhiteKnight = 0,
    this.winCountDarkWizard = 0,
    this.drawCountDrunkard = 0,
    this.drawCountNovice = 0,
    this.drawCountWhiteKnight = 0,
    this.drawCountDarkWizard = 0,
    this.lossCountDrunkard = 0,
    this.lossCountNovice = 0,
    this.lossCountWhiteKnight = 0,
    this.lossCountDarkWizard = 0,
    this.rank = 'Drunkard',
    this.rankExp = 0,
    this.winCount = 0,
    this.drawCount = 0,
    this.lossCount = 0,
    this.winRate = 0,
  });

  Map<String, Object?> toJson() => {
        UserStatisticField.winCountDrunkard: winCountDarkWizard,
        UserStatisticField.winCountNovice: winCountNovice,
        UserStatisticField.winCountWhiteKnight: winCountWhiteKnight,
        UserStatisticField.winCountDarkWizard: winCountDarkWizard,
        UserStatisticField.drawCountDrunkard: drawCountDrunkard,
        UserStatisticField.drawCountNovice: drawCountNovice,
        UserStatisticField.drawCountWhiteKnight: drawCountWhiteKnight,
        UserStatisticField.drawCountDarkWizard: drawCountDarkWizard,
        UserStatisticField.lossCountDrunkard: lossCountDarkWizard,
        UserStatisticField.lossCountNovice: lossCountNovice,
        UserStatisticField.lossCountWhiteKnight: lossCountWhiteKnight,
        UserStatisticField.lossCountDarkWizard: lossCountDarkWizard,
        UserStatisticField.rank: rank,
        UserStatisticField.rankExp: rankExp,
      };

  UserStatistic copy({
    int? winCountDrunkard,
    int? winCountNovice,
    int? winCountWhiteKnight,
    int? winCountDarkWizard,
    int? drawCountDrunkard,
    int? drawCountNovice,
    int? drawCountWhiteKnight,
    int? drawCountDarkWizard,
    int? lossCountDrunkard,
    int? lossCountNovice,
    int? lossCountWhiteKnight,
    int? lossCountDarkWizard,
    String? rank,
    int? rankExp,
    // wait ?
    int? winRate,
  }) {
    return UserStatistic(
      winCountDrunkard: winCountDrunkard ?? this.winCountDrunkard,
      winCountNovice: winCountNovice ?? this.winCountNovice,
      winCountWhiteKnight: winCountWhiteKnight ?? this.winCountWhiteKnight,
      winCountDarkWizard: winCountDarkWizard ?? this.winCountDarkWizard,
      drawCountDrunkard: drawCountDrunkard ?? this.drawCountDrunkard,
      drawCountNovice: drawCountNovice ?? this.drawCountNovice,
      drawCountWhiteKnight: drawCountWhiteKnight ?? this.drawCountWhiteKnight,
      drawCountDarkWizard: drawCountDarkWizard ?? this.drawCountDarkWizard,
      lossCountDrunkard: lossCountDrunkard ?? this.lossCountDrunkard,
      lossCountNovice: lossCountNovice ?? this.lossCountNovice,
      lossCountWhiteKnight: lossCountWhiteKnight ?? this.lossCountWhiteKnight,
      lossCountDarkWizard: lossCountDarkWizard ?? this.lossCountDarkWizard,
      rank: rank ?? this.rank,
      rankExp: rankExp ?? this.rankExp,
      winRate: winRate ?? this.winRate,
    );
  }

  Future<UserStatistic> fromJson(Map<String, Object?> json) async {
    final Map<String, dynamic> absoluteCount = await StatisticDatabase.instance.calculateAbsoluteCount();
    return UserStatistic(
      winCountDrunkard: json[UserStatisticField.winCountDrunkard] as int,
      winCountNovice: json[UserStatisticField.winCountNovice] as int,
      winCountWhiteKnight: json[UserStatisticField.winCountWhiteKnight] as int,
      winCountDarkWizard: json[UserStatisticField.winCountDarkWizard] as int,
      drawCountDrunkard: json[UserStatisticField.drawCountDrunkard] as int,
      drawCountNovice: json[UserStatisticField.drawCountNovice] as int,
      drawCountWhiteKnight: json[UserStatisticField.drawCountWhiteKnight] as int,
      drawCountDarkWizard: json[UserStatisticField.drawCountDarkWizard] as int,
      lossCountDrunkard: json[UserStatisticField.lossCountDrunkard] as int,
      lossCountNovice: json[UserStatisticField.lossCountNovice] as int,
      lossCountWhiteKnight: json[UserStatisticField.lossCountWhiteKnight] as int,
      lossCountDarkWizard: json[UserStatisticField.lossCountDarkWizard] as int,
      rank: json[UserStatisticField.rank] as String,
      rankExp: json[UserStatisticField.rankExp] as int,
      winCount: absoluteCount['winCount'] as int,
      drawCount: absoluteCount['drawCount'] as int,
      lossCount: absoluteCount['lossCount'] as int,
      winRate: absoluteCount['winRate'] as int,
    );
  }
}
