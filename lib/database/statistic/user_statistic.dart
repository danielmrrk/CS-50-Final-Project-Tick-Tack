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
    this.rank = 'drunkard',
    this.rankExp = 0,
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
}
