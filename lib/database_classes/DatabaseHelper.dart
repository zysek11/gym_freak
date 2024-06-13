import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Exercise.dart';
import 'ExerciseController.dart';
import 'Group.dart';
import 'Workout.dart';

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
            name TEXT PRIMARY KEY,
            type INTEGER,
            iconPath TEXT,
            group TEXT,
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
            name TEXT PRIMARY KEY,
            exercises TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE profiles (
            name TEXT PRIMARY KEY
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

  // Implementacja CRUD dla innych klas
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
}
