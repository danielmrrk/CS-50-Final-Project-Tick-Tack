import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:tic_tac/database/statistic/challenge.dart';
import 'package:tic_tac/database/statistic/challenge_data.dart';
import 'package:tic_tac/database/statistic/user_statistic.dart';

class StatisticDatabase {
  static final StatisticDatabase instance = StatisticDatabase._init();
  static Database? _database;
  StatisticDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase('challenge.db');
    return _database!;
  }

  Future<Database?> initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDatabaseWithContent);
  }

  Future<void> _createDatabaseWithContent(Database db, int version) async {
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const String textType = 'TEXT NOT NULL';
    const String boolType = 'BOOLEAN NOT NULL';
    const String intType = 'INTEGER NOT NULL';
    const String intNullableType = 'INTEGER NULL';

    await db.execute(
      '''CREATE TABLE $challengeTable (
      ${ChallengeField.id} $idType,
      ${ChallengeField.content} $textType,
      ${ChallengeField.exp} $intType,
      ${ChallengeField.cleared} $boolType,
      ${ChallengeField.progress} $intNullableType,
      ${ChallengeField.challengeGoal} $intNullableType,
      ${ChallengeField.showChallenge} $boolType,
      ${ChallengeField.difficulty} $textType,
      ${ChallengeField.clearCondition} $textType
    )''',
    );

    for (Challenge challenge in challengeData) {
      await db.insert(
        challengeTable,
        challenge.toJson(),
      );
    }

    await db.execute(
      '''CREATE TABLE $userStatisticTable (
      ${UserStatisticField.winCountDrunkard} $intType,
      ${UserStatisticField.winCountNovice} $intType,
      ${UserStatisticField.winCountWhiteKnight} $intType,
      ${UserStatisticField.winCountDarkWizard} $intType,
      ${UserStatisticField.drawCountDrunkard} $intType, 
      ${UserStatisticField.drawCountNovice} $intType,
      ${UserStatisticField.drawCountWhiteKnight} $intType,
      ${UserStatisticField.drawCountDarkWizard} $intType,
      ${UserStatisticField.lossCountDrunkard} $intType,
      ${UserStatisticField.lossCountNovice} $intType,
      ${UserStatisticField.lossCountWhiteKnight} $intType,
      ${UserStatisticField.lossCountDarkWizard} $intType,
      ${UserStatisticField.rank} $textType,
      ${UserStatisticField.rankExp} $intType
    )''',
    );
    await db.insert(
      userStatisticTable,
      UserStatistic().toJson(),
    );
  }

  Future<Challenge?> readShowableChallenge() async {
    final db = await instance.database;
    final maps = await db.query(
      challengeTable,
      columns: ChallengeField.values,
      where: '${ChallengeField.showChallenge} == ?',
      whereArgs: [1],
    );

    if (maps.isNotEmpty) {
      return Challenge.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Challenge>> readAllShowableChallenges() async {
    final db = await instance.database;
    final result = await db.query(
      challengeTable,
      where: '${ChallengeField.showChallenge} == ?',
      whereArgs: [1],
    );
    return result.map((json) => Challenge.fromJson(json)).toList();
  }

  Future<int> updateChallenge(
      {required Challenge challenge,
      String? content,
      int? exp,
      bool? cleared,
      int? progress,
      int? progressGoal,
      bool? showChallenge,
      String? difficulty,
      String? clearCondition}) async {
    final db = await instance.database;
    if (content != null) {
      challenge = challenge.copy(content: content);
    } else if (exp != null) {
      challenge = challenge.copy(exp: exp);
    } else if (progressGoal != null) {
      challenge = challenge.copy(progressGoal: progressGoal);
    } else if (difficulty != null) {
      challenge = challenge.copy(difficulty: difficulty);
    }
    if (progress != null) {
      challenge = challenge.copy(progress: progress);
    }
    if (cleared != null) {
      challenge = challenge.copy(cleared: cleared);
    }
    if (showChallenge != null) {
      challenge = challenge.copy(showChallenge: showChallenge);
    }
    return db.update(
      challengeTable,
      challenge.toJson(),
      where: '${ChallengeField.id} == ?',
      whereArgs: [challenge.id],
    );
  }

  Future<int> deleteChallenge(int id) async {
    final db = await instance.database;
    return await db.delete(
      challengeTable,
      where: '${ChallengeField.id} == ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteChallengeTable() async {
    final db = await instance.database;
    return await db.delete(
      challengeTable,
    );
  }

  Future<int> deleteUserStatisticTable() async {
    final db = await instance.database;
    return await db.delete(
      userStatisticTable,
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  Future<UserStatistic> readUserStatistic() async {
    final db = await instance.database;
    final result = await db.query(
      userStatisticTable,
      limit: 1,
    );
    return UserStatistic().fromJson(result.first);
  }

  Future<Map<String, dynamic>> calculateAbsoluteCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
SELECT 
  SUM(${UserStatisticField.winCountDrunkard}) + 
  SUM(${UserStatisticField.winCountNovice}) + 
  SUM(${UserStatisticField.winCountWhiteKnight}) + 
  SUM(${UserStatisticField.winCountDarkWizard}) AS winCount,

  SUM(${UserStatisticField.drawCountDrunkard}) +
  SUM(${UserStatisticField.drawCountNovice}) +
  SUM(${UserStatisticField.drawCountWhiteKnight}) +
  SUM(${UserStatisticField.drawCountDarkWizard}) AS drawCount,

  SUM(${UserStatisticField.lossCountDrunkard}) +
  SUM(${UserStatisticField.lossCountNovice}) +
  SUM(${UserStatisticField.lossCountWhiteKnight}) +
  SUM(${UserStatisticField.lossCountDarkWizard}) AS lossCount
  FROM $userStatisticTable
''');
// result.first is an unmodifiable map
    final Map<String, dynamic> userStatisticMap = Map<String, dynamic>.from(result.first);
    final int absoluteCount =
        (userStatisticMap['winCount'] as int) + (userStatisticMap['lossCount'] as int) + (userStatisticMap['drawCount'] as int);
    if (absoluteCount != 0) {
      userStatisticMap['winRate'] = (userStatisticMap['winCount'] as int) ~/ absoluteCount;
    } else {
      userStatisticMap['winRate'] = 0;
    }
    return userStatisticMap;
  }

  Future<void> updateUserStatistic({
    String? difficulty,
    String? result,
    String? rank,
    String? rankExp,
  }) async {
    final db = await instance.database;
    UserStatistic userStatistic = await readUserStatistic();
    // need to update rankExp & rank
    if (difficulty != null || result != null) {
      userStatistic = _updateGameCount(userStatistic, difficulty!, result!);
    } else {
      return;
    }
    db.update(userStatisticTable, userStatistic.toJson());
  }

  UserStatistic _updateGameCount(
    UserStatistic userStatistic,
    String difficulty,
    String result,
  ) {
    switch (difficulty) {
      case ("drunkard"):
        switch (result) {
          case ("win"):
            userStatistic = userStatistic.copy(winCountDrunkard: userStatistic.winCountDrunkard + 1);
            break;
          case ("draw"):
            userStatistic = userStatistic.copy(drawCountDrunkard: userStatistic.drawCountDrunkard + 1);
            break;
          case ("loss"):
            userStatistic = userStatistic.copy(lossCountDrunkard: userStatistic.lossCountDrunkard + 1);
            break;
        }
        break;
      case ("novice"):
        switch (result) {
          case ("win"):
            userStatistic = userStatistic.copy(winCountNovice: userStatistic.winCountNovice + 1);
            break;
          case ("draw"):
            userStatistic = userStatistic.copy(drawCountNovice: userStatistic.drawCountNovice + 1);
            break;
          case ("loss"):
            userStatistic = userStatistic.copy(lossCountNovice: userStatistic.lossCountNovice + 1);
            break;
        }
        break;
      case ("white_knight"):
        switch (result) {
          case ("win"):
            userStatistic = userStatistic.copy(winCountWhiteKnight: userStatistic.winCountWhiteKnight + 1);
            break;
          case ("draw"):
            userStatistic = userStatistic.copy(drawCountWhiteKnight: userStatistic.drawCountWhiteKnight + 1);
            break;
          case ("loss"):
            userStatistic = userStatistic.copy(lossCountWhiteKnight: userStatistic.lossCountWhiteKnight + 1);
            break;
        }
        break;
      case ("dark_wizard"):
        switch (result) {
          case ("win"):
            userStatistic = userStatistic.copy(winCountDarkWizard: userStatistic.winCountDarkWizard + 1);
            break;
          case ("draw"):
            userStatistic = userStatistic.copy(drawCountDarkWizard: userStatistic.drawCountDarkWizard + 1);
            break;
          case ("loss"):
            userStatistic = userStatistic.copy(lossCountDarkWizard: userStatistic.lossCountDarkWizard + 1);
            break;
        }
        break;
    }
    return userStatistic;
  }
}
