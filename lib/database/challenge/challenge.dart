const String challengeTable = 'challenge';

class ChallengeField {
  static final List<String> values = [
    id,
    content,
    exp,
    achieved,
    progress,
    challengeGoal,
    showChallenge,
  ];
  static const id = '_id';
  static const content = 'content';
  static const exp = 'exp';
  static const achieved = 'achieved';
  static const progress = 'progress';
  static const challengeGoal = 'challenge_goal';
  static const showChallenge = 'show_challenge';
}

class Challenge {
  const Challenge({
    this.id,
    required this.content,
    required this.exp,
    required this.achieved,
    this.progress,
    this.challengeGoal,
    this.showChallenge = false,
  });
  final int? id;
  final String content;
  final int exp;
  final bool achieved;
  final int? progress;
  final int? challengeGoal;
  final bool showChallenge;

  static Challenge fromJson(Map<String, Object?> json) => Challenge(
        id: json[ChallengeField.id] as int?,
        content: json[ChallengeField.content] as String,
        exp: json[ChallengeField.exp] as int,
        achieved: json[ChallengeField.achieved] == 1,
        progress: json[ChallengeField.progress] as int?,
        challengeGoal: json[ChallengeField.challengeGoal] as int?,
        showChallenge: json[ChallengeField.showChallenge] == 1,
      );

  Map<String, Object?> toJson() => {
        ChallengeField.id: id,
        ChallengeField.content: content,
        ChallengeField.exp: exp,
        ChallengeField.achieved: achieved ? 1 : 0,
        ChallengeField.progress: progress,
        ChallengeField.challengeGoal: challengeGoal,
        ChallengeField.showChallenge: showChallenge ? 1 : 0,
      };

  Challenge copy({
    int? id,
    String? content,
    int? exp,
    bool? achieved,
    int? progress,
    int? challengeGoal,
    bool? showChallenge,
  }) =>
      Challenge(
        id: id ?? this.id,
        content: content ?? this.content,
        exp: exp ?? this.exp,
        achieved: achieved ?? this.achieved,
        progress: progress ?? this.progress,
        challengeGoal: challengeGoal ?? this.challengeGoal,
        showChallenge: showChallenge ?? this.showChallenge,
      );
}
