class StatisticField {
  final List<String> values = [
    wins,
    draws,
    losses,
    winRate,
    rank,
  ];
  static const wins = 'wins';
  static const draws = 'draws';
  static const losses = 'losses';
  static const winRate = 'win_rate';
  static const rank = 'rank';
  static const rankExp = 'rank_exp';
  static const rankExpNeeded = 'rank_exp_needed';
}

class Statistic {
  Statistic({
    required this.wins,
    required this.draws,
    required this.losses,
    required this.winRate,
  });
  final int wins;
  final int draws;
  final int losses;
  final int winRate;
}
