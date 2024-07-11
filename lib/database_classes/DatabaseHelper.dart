import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Exercise.dart';
import 'ExerciseController.dart';
import 'Group.dart';
import 'Workout.dart';
import 'Profile.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'fitness.db'),
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE exercises (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          type TEXT,
          application INTEGER,
          iconPath TEXT,
          groupName TEXT,
          description TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE exercise_controllers (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          exercise TEXT,
          series INTEGER,
          weights TEXT,
          repetitions TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE workouts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          exercises TEXT,
          date TEXT,
          intensity INTEGER,
          satisfaction INTEGER,
          comment TEXT,
          time INTEGER
        )
      ''');
        await db.execute('''
        CREATE TABLE groups (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          exercises TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE profiles (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          age INTEGER,
          weight REAL,
          height REAL,
          date TEXT
        )
      ''');
      },
      version: 1,
    );
  }

  Future<void> insertExercise(Exercise exercise) async {
    final db = await database;
    await db.insert(
      'exercises',
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Exercise>> getExercises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('exercises');
    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  Future<void> deleteExercise(int id) async {
    final db = await database;
    await db.delete(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateExercise(Exercise exercise) async {
    final db = await database;
    await db.update(
      'exercises',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<void> insertExerciseController(ExerciseController controller) async {
    final db = await database;
    await db.insert(
      'exercise_controllers',
      controller.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ExerciseController>> getExerciseControllers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('exercise_controllers');
    return List.generate(maps.length, (i) {
      return ExerciseController.fromMap(maps[i]);
    });
  }

  Future<void> deleteExerciseController(int id) async {
    final db = await database;
    await db.delete(
      'exercise_controllers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertWorkout(Workout workout) async {
    final db = await database;
    await db.insert(
      'workouts',
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Workout>> getWorkouts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('workouts');
    return List.generate(maps.length, (i) {
      return Workout.fromMap(maps[i]);
    });
  }

  Future<void> deleteWorkout(int id) async {
    final db = await database;
    await db.delete(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertGroup(Groups group) async {
    final db = await database;
    await db.insert(
      'groups',
      group.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Groups>> getGroups() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('groups');
    return List.generate(maps.length, (i) {
      return Groups.fromMap(maps[i]);
    });
  }

  Future<void> deleteGroup(int id) async {
    final db = await database;
    await db.delete(
      'groups',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertProfile(Profile profile) async {
    final db = await database;
    await db.insert(
      'profiles',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Profile?> getProfile() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('profiles');
    if (maps.isNotEmpty) {
      return Profile.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateProfile(Profile profile) async {
    final db = await database;
    await db.update(
      'profiles',
      profile.toMap(),
      where: 'name = ?',
      whereArgs: [profile.name],
    );
  }

  Future<void> deleteProfile(int id) async {
    final db = await database;
    await db.delete(
      'profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
