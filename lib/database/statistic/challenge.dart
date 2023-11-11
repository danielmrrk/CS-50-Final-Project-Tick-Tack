const String challengeTable = 'challenge';

class ChallengeField {
  static final List<String> values = [
    id,
    content,
    exp,
    cleared,
    progress,
    challengeGoal,
    showChallenge,
    difficulty,
    clearCondition,
  ];
  static const id = '_id';
  static const content = 'content';
  static const exp = 'exp';
  static const cleared = 'cleared';
  static const progress = 'progress';
  static const challengeGoal = 'challenge_goal';
  static const showChallenge = 'show_challenge';
  static const difficulty = 'difficulty';
  static const clearCondition = 'clear_condition';
}

class Challenge {
  const Challenge({
    this.id,
    required this.content,
    required this.exp,
    this.cleared = false,
    this.progress,
    this.progressGoal,
    this.showChallenge = false,
    required this.difficulty,
    required this.clearCondition,
  });
  final int? id;
  final String content;
  final int exp;
  final bool cleared;
  final int? progress;
  final int? progressGoal;
  final bool showChallenge;
  final String difficulty;
  final String clearCondition;

  static Challenge fromJson(Map<String, Object?> json) => Challenge(
        id: json[ChallengeField.id] as int?,
        content: json[ChallengeField.content] as String,
        exp: json[ChallengeField.exp] as int,
        cleared: json[ChallengeField.cleared] == 1,
        progress: json[ChallengeField.progress] as int?,
        progressGoal: json[ChallengeField.challengeGoal] as int?,
        showChallenge: json[ChallengeField.showChallenge] == 1,
        difficulty: json[ChallengeField.difficulty] as String,
        clearCondition: json[ChallengeField.clearCondition] as String,
      );

  Map<String, Object?> toJson() => {
        ChallengeField.id: id,
        ChallengeField.content: content,
        ChallengeField.exp: exp,
        ChallengeField.cleared: cleared ? 1 : 0,
        ChallengeField.progress: progress,
        ChallengeField.challengeGoal: progressGoal,
        ChallengeField.showChallenge: showChallenge ? 1 : 0,
        ChallengeField.difficulty: difficulty,
        ChallengeField.clearCondition: clearCondition,
      };

  Challenge copy({
    int? id,
    String? content,
    int? exp,
    bool? cleared,
    int? progress,
    int? progressGoal,
    bool? showChallenge,
    String? difficulty,
    String? clearCondition,
  }) =>
      Challenge(
        id: id ?? this.id,
        content: content ?? this.content,
        exp: exp ?? this.exp,
        cleared: cleared ?? this.cleared,
        progress: progress ?? this.progress,
        progressGoal: progressGoal ?? this.progressGoal,
        showChallenge: showChallenge ?? this.showChallenge,
        difficulty: difficulty ?? this.difficulty,
        clearCondition: clearCondition ?? this.clearCondition,
      );
}
