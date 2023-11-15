import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:tic_tac/database/statistic/challenge.dart';
import 'package:tic_tac/database/statistic/challenge_data.dart';
import 'package:tic_tac/statistic/user_statistic_service.dart';

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

  Future<void> onResultUpdateChallenge({required String resultKey, required String difficultyDisplayName}) async {
    final db = await StatisticDatabase.instance.database;
    final String clearConditionDisplay = difficultyDisplayName.replaceAll(' ', '');
    await db.rawQuery('''
    UPDATE $challengeTable
    SET ${ChallengeField.cleared} = 1
    WHERE (${ChallengeField.progress} IS NULL OR ${ChallengeField.progress} >= ${ChallengeField.challengeGoal} - 1)
          AND (${ChallengeField.clearCondition} = 'ClearCondition.$resultKey' OR 
          ${ChallengeField.clearCondition} = 'ClearCondition.$resultKey$clearConditionDisplay')
          AND ${ChallengeField.showChallenge} = 1;
''');
    await db.rawQuery('''
    UPDATE $challengeTable
    SET ${ChallengeField.progress} = ${ChallengeField.progress} + 1
    WHERE (${ChallengeField.clearCondition} = 'ClearCondition.$resultKey' OR ${ChallengeField.clearCondition} = 'ClearCondition.$resultKey$clearConditionDisplay')
          AND ${ChallengeField.progress} IS NOT NULL AND ${ChallengeField.progress} < ${ChallengeField.challengeGoal}
          AND ${ChallengeField.showChallenge} = 1;
          ''');
    UserStatisticService.instance.updateGameCount(difficultyDisplayName, resultKey);
  }

  Future<void> onCollectUpdateChallenge(Challenge challenge) async {
    final db = await StatisticDatabase.instance.database;
    db.rawQuery('''
    UPDATE $challengeTable
    SET ${ChallengeField.showChallenge} = 0
    WHERE ${ChallengeField.id} = ${challenge.id} AND ${ChallengeField.cleared} = 1;
''');
    UserStatisticService.instance.maybeUpdateUserStatus(challenge.exp);
  }

  Future<void> updateUnshowableChallenges(String difficultyDisplayName) async {
    final db = await StatisticDatabase.instance.database;
    db.update(
      challengeTable,
      {ChallengeField.showChallenge: 1},
      where: "${ChallengeField.difficulty} = ?",
      whereArgs: [difficultyDisplayName],
    );
  }

  Future<int> deleteChallengeTable() async {
    final db = await instance.database;
    return await db.delete(
      challengeTable,
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
