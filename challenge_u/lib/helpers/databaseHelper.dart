import 'dart:convert';

import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

import '../classes/challenge.dart';
import '../classes/goal.dart';
import '../classes/sport.dart';
import '../classes/training.dart';

class DatabaseHelper {
  Future<Database> getChallengeBase() async {
    final dbPath = await getDatabasesPath();
    final Database database = await openDatabase(
      join(dbPath, "userChallenges.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE challenges (id TEXT PRIMARY KEY, name TEXT)");
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertChallenge(Challenge challenge) async {
    final Database db = await getChallengeBase();

    await db.insert(
      'challenges',
      {
        'id': challenge.id,
        'name': challenge.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeChallenge(String challengeId) async {
    final Database db = await getChallengeBase();
    await db.delete(
      'challenges',
      where: 'id = ?',
      whereArgs: [challengeId],
    );
  }

  Future<List<Challenge>> getAllChallenges() async {
    final Database db = await getChallengeBase();
    final List<Map<String, dynamic>> mapChallenges =
        await db.query('challenges');

    return List.generate(mapChallenges.length, (i) {
      return Challenge(
        mapChallenges[i]['name'],
        mapChallenges[i]['id'],
      );
    });
  }

  Future<Database> getTrainingBase() async {
    final dbPath = await getDatabasesPath();
    final Database database = await openDatabase(
      join(dbPath, "userTrainings.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE trainings (id TEXT PRIMARY KEY, date TEXT, sport INTEGER, reps INTEGER)");
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertTraining(Training training) async {
    final Database db = await getTrainingBase();

    await db.insert(
      'trainings',
      {
        'id': training.id,
        'date': training.datum.toString(),
        'sport': training.sport.enumToIndex(training.sport),
        'reps': training.wiederholungen.toInt(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeTraining(String trainingId) async {
    final Database db = await getTrainingBase();
    await db.delete(
      'trainings',
      where: 'id = ?',
      whereArgs: [trainingId],
    );
  }

  Future<List<Training>> getAllTrainings() async {
    final Database db = await getTrainingBase();
    final List<Map<String, dynamic>> mapTrainings = await db.query('trainings');

    return List.generate(mapTrainings.length, (i) {
      return Training(
        Sport.nichtAusgewaehlt.indexToEnum(mapTrainings[i]['sport']),
        mapTrainings[i]['reps'].toDouble(),
        DateTime.parse(mapTrainings[i]['date']),
        mapTrainings[i]['id'],
      );
    });
  }

  Future<Database> getGoalBase() async {
    final dbPath = await getDatabasesPath();
    final Database database = await openDatabase(
      join(dbPath, "userGoals.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE goals (id TEXT PRIMARY KEY, challengeId TEXT, days INTEGER, sport INTEGER, reps INTEGER)");
      },
      version: 1,
    );
    //databaseFactory.deleteDatabase(database.path);
    return database;
  }

  Future<void> insertGoal(goal) async {
    final Database db = await getGoalBase();
    await db.insert(
      'goals',
      {
        'id': goal.id,
        'challengeId': goal.challengeID,
        'days': goal.tageMuss.toInt(),
        'sport': goal.sport.enumToIndex(goal.sport),
        'reps': goal.wiederholungenMuss.toInt(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Goal>> getAllGoals() async {
    final Database db = await getGoalBase();
    final List<Map<String, dynamic>> mapGoals = await db.query('goals');

    return List.generate(mapGoals.length, (i) {
      Goal goal = Goal(
        Sport.nichtAusgewaehlt.indexToEnum(mapGoals[i]['sport']),
        mapGoals[i]['reps'].toDouble(),
        mapGoals[i]['days'].toDouble(),
        mapGoals[i]['id'],
      );
      goal.challengeID = mapGoals[i]['challengeId']!;
      return goal;
    });
  }

  Future<void> removeGoal(String id) async {
    final Database db = await getGoalBase();
    await db.delete(
      'goals',
      where: 'challengeID = ?',
      whereArgs: [id],
    );
  }
}
