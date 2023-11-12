import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:tic_tac/database/statistic/challenge.dart';
import 'package:tic_tac/database/statistic/challenge_data.dart';

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

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
