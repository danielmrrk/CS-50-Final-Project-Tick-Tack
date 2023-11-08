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
    if (_database != null) return _database!;
    _database = await _initDatabase('challenge.db');
    return _database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print("dbPath: $dbPath");
    print("path: $path");
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
      ${ChallengeField.difficulty} $textType
    )''',
    );

    for (Challenge challenge in challengeData) {
      final id = await db.insert(
        challengeTable,
        challenge.toJson(),
      );
      if (id != -1) {
        print("Succesfull");
      } else {
        print("not successful");
      }
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

  Future<Challenge> createChallenge(Challenge challenge) async {
    final db = await instance.database;
    final id = await db.insert(
      challengeTable,
      challenge.toJson(),
    );
    return challenge.copy(id: id);
  }

  Future<Challenge?> readShowableChallenge(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      challengeTable,
      columns: ChallengeField.values,
      where: '${ChallengeField.id} == ? AND ${ChallengeField.showChallenge} == ?',
      whereArgs: [id, 1],
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

  Future<int> updateChallenge(Challenge challenge) async {
    final db = await instance.database;
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

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
