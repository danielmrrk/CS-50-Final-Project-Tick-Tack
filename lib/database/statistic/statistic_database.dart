import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:tic_tac/database/statistic/challenge.dart';

class ChallengeDatabase {
  static final ChallengeDatabase instance = ChallengeDatabase._init();
  static Database? _database;
  ChallengeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase('challenge.db');
    return _database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const String textType = 'TEXT NOT NULL';
    const String boolType = 'BOOLEAN NOT NULL';
    const String intType = 'INTEGER NOT NULL';
    const String intNullableType = 'INTEGER NULL';

    await db.execute('''CREATE TABLE $challengeTable (
      ${ChallengeField.id} $idType,
      ${ChallengeField.content} $textType,
      ${ChallengeField.exp} $intType,
      ${ChallengeField.achieved} $boolType,
      ${ChallengeField.progress} $intNullableType,
      ${ChallengeField.challengeGoal} $intNullableType,
      ${ChallengeField.showChallenge} $boolType,
      ${ChallengeField.difficulty} $textType,
    )
''');
  }

  Future<Challenge> create(Challenge challenge) async {
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

  Future<int> update(Challenge challenge) async {
    final db = await instance.database;
    return db.update(
      challengeTable,
      challenge.toJson(),
      where: '${ChallengeField.id} == ?',
      whereArgs: [challenge.id],
    );
  }

  Future<int> delete(int id) async {
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
