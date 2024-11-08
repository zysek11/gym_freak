import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Exercise.dart';
import 'ExerciseWrapper.dart';
import 'Group.dart';
import 'Measurement.dart';
import 'Supplement.dart';
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
          groups TEXT,
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
          intensity REAL,
          satisfaction REAL,
          comment TEXT,
          time INTEGER
        )
      ''');
        await db.execute('''
        CREATE TABLE groups (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          iconPath TEXT,
          exercises TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE profiles (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          dob INTEGER
        )
      ''');

        await db.execute('''
        CREATE TABLE measurement (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          value REAL,
          unit TEXT,
          date TEXT,
          active INTEGER,
          profile_id INTEGER,
          FOREIGN KEY (profile_id) REFERENCES profiles(id)
        )
      ''');

        await db.execute('''
        CREATE TABLE supplement (
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         name TEXT,
         value REAL,
         unit TEXT,
         indefinite INTEGER,
         dateOfStart TEXT,
         dateOfEnd TEXT,
         today INTEGER,
         Profile_id INTEGER,
         checkCounter INTEGER, 
         counter INTEGER,
         suppLimit INTEGER,
         FOREIGN KEY (Profile_id) REFERENCES profiles(id)
       )
      ''');
      },
      version: 1,
    );
  }

  Future<void> insertMeasurement(Measurement measurement) async {
    final db = await database;
    await db.insert(
      'measurement',
      measurement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMeasurements(List<Measurement> measurements) async {
    final db = await database;

    // Start a batch operation
    Batch batch = db.batch();

    // Loop through each measurement in the list
    for (var measurement in measurements) {
      batch.insert(
        'measurement',
        measurement.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Commit the batch (this executes all the inserts)
    await batch.commit(noResult: true);
  }


  Future<List<Measurement>> getLatestMeasurementsByProfile(int profileId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT name, id, value, unit, MAX(date) as date, profile_id
    FROM measurement
    WHERE profile_id = ?
    GROUP BY name
    ORDER BY date DESC;
  ''', [profileId]);

    return List.generate(maps.length, (i) {
      return Measurement.fromMap(maps[i]);
    });
  }



  Future<void> updateMeasurement(Measurement measurement) async {
    final db = await database;
    await db.update(
      'measurement',
      measurement.toMap(),
      where: 'id = ?',
      whereArgs: [measurement.id],
    );
  }

  Future<void> deleteMeasurement(int id) async {
    final db = await database;
    await db.delete(
      'measurement',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteMeasurementsByName(String name) async {
    final db = await database;
    await db.delete(
      'measurement',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<bool> checkMeasurementByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'measurement',
      where: 'name = ?',
      whereArgs: [name],
    );
    return results.isEmpty;
  }


  Future<List<Measurement>> getMeasurementsByNameSortedByDate(String name) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'measurement',
      where: 'name = ?',
      whereArgs: [name],
      orderBy: 'date DESC', // Sortowanie rosnąco według daty
    );

    return List.generate(maps.length, (i) {
      return Measurement.fromMap(maps[i]);
    });
  }

  Future<void> insertSupplement(Supplement supplement) async {
    final db = await database;
    await db.insert(
      'supplement',
      supplement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteSupplement(int id) async {
    final db = await database;
    await db.delete(
      'supplement',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateSupplement(Supplement supplement) async {
    final db = await database;
    await db.update(
      'supplement',
      supplement.toMap(),
      where: 'id = ?',
      whereArgs: [supplement.id],
    );
  }

  Future<List<Supplement>> getLatestSupplementsByProfile(int profileId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'supplement',
      where: 'Profile_id = ?',
      whereArgs: [profileId],
    );

    return List.generate(maps.length, (i) {
      return Supplement.fromMap(maps[i]);
    });
  }

  Future<bool> checkSupplementByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'supplement',
      where: 'name = ?',
      whereArgs: [name],
    );
    return results.isEmpty;
  }

  Future<void> updateSupplementCounter(int id, int newCounterValue) async {
    final db = await database;
    await db.update(
      'supplement',
      {'counter': newCounterValue},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateSupplementLimitAndCounterStatus(int id, int newLimit, bool checkCounter) async {
    final db = await database;
    await db.update(
      'supplement',
      {
        'suppLimit': newLimit,
        'checkCounter': checkCounter ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
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

  Future<List<Exercise>> getExercisesByIds(Iterable<int> exerciseIds) async {
    final db = await database;

    // Konwertowanie Iterable<int> na ciąg znaków rozdzielony przecinkami
    String ids = exerciseIds.join(',');

    // Pobieranie ćwiczeń, których ID są w przekazanej liście
    final List<Map<String, dynamic>> maps = await db.query(
      'exercises',
      where: 'id IN ($ids)',
    );

    // Konwertowanie wyników z bazy danych na obiekty Exercise
    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  Future<List<Exercise>> getExercises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('exercises');
    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  Future<Exercise?> getLastExercise() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercises',
      orderBy: 'id DESC', // Sortowanie malejąco według id
      limit: 1, // Pobieramy tylko jedno, ostatnie ćwiczenie
    );

    if (maps.isNotEmpty) {
      return Exercise.fromMap(maps.first);
    } else {
      return null; // Jeśli nie ma żadnych ćwiczeń, zwróć null
    }
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

  Future<void> insertExerciseController(ExerciseWrapper controller) async {
    final db = await database;
    await db.insert(
      'exercise_controllers',
      controller.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ExerciseWrapper>> getExerciseControllers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('exercise_controllers');
    return List.generate(maps.length, (i) {
      return ExerciseWrapper.fromMap(maps[i]);
    });
  }

  Future<List<String>> getExerciseTypesByIds(List<int> exerciseIds) async {
    final db = await database;

    // Convert the list of IDs to a comma-separated string
    final String ids = exerciseIds.join(',');

    // Query the database to get distinct types of exercises for the given IDs
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT DISTINCT type FROM exercises WHERE id IN ($ids)',
    );

    // Map the result to a list of types and return
    return result.map((row) => row['type'] as String).toList();
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

  Future<void> updateGroup(Groups group) async {
    final db = await database;
    await db.update(
      'groups',
      group.toMap(),
      where: 'id = ?',
      whereArgs: [group.id],
    );
  }

  Future<List<Groups>> getGroups() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('groups');
    return List.generate(maps.length, (i) {
      return Groups.fromMap(maps[i]);
    });
  }

  Future<Groups?> getLastGroup() async {
    final db = await database;

    // Pobierz grupę z najwyższym ID, co oznacza ostatnio dodaną grupę
    final List<Map<String, dynamic>> maps = await db.query(
      'groups',
      orderBy: 'id DESC', // Sortowanie w odwrotnej kolejności według ID
      limit: 1, // Ograniczenie do jednej grupy
    );

    if (maps.isNotEmpty) {
      return Groups.fromMap(maps.first); // Zwróć pierwszą (i jedyną) grupę
    } else {
      return null; // Jeśli nie ma żadnej grupy
    }
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
