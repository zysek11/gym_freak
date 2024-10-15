import 'package:shared_preferences/shared_preferences.dart';

import '../database_classes/Exercise.dart';
import 'ExercisesController.dart';

class ExerciseTypesManager {
  // Singleton pattern
  static final ExerciseTypesManager _instance = ExerciseTypesManager._internal();
  factory ExerciseTypesManager() => _instance;

  // Private constructor
  ExerciseTypesManager._internal() {
    _loadCustomExercises(); // Load custom exercises on initialization
  }

  // Built-in (non-modifiable) exercises
  final List<Map<String, dynamic>> _builtInExercises = [
    {'id': 0, 'name': 'Czworogłowe uda', 'modifiable': false},
    {'id': 1, 'name': 'Dwugłowe uda / pośladki', 'modifiable': false},
    {'id': 2, 'name': 'Plecy', 'modifiable': false},
    {'id': 3, 'name': 'Klatka piersiowa', 'modifiable': false},
    {'id': 4, 'name': 'Barki', 'modifiable': false},
    {'id': 5, 'name': 'Brzuch', 'modifiable': false},
    {'id': 6, 'name': 'Triceps', 'modifiable': false},
    {'id': 7, 'name': 'Biceps', 'modifiable': false},
    {'id': 8, 'name': 'Łydki', 'modifiable': false},
    {'id': 9, 'name': 'Ćwiczenia domowe', 'modifiable': false},
    {'id': 10, 'name': 'Street workout', 'modifiable': false},
    {'id': 11, 'name': 'Crossfit', 'modifiable': false},
    {'id': 12, 'name': 'Kettlebell', 'modifiable': false},
    {'id': 13, 'name': 'Rozciąganie', 'modifiable': false},
    {'id': 14, 'name': 'Mobilizacje', 'modifiable': false},
    {'id': 15, 'name': 'Rolowanie', 'modifiable': false},
  ];

  // List of custom exercises
  List<Map<String, dynamic>> _customExercises = [];

  // Get all exercises (built-in + custom)
  List<Map<String, dynamic>> get allExercises => [..._builtInExercises, ..._customExercises];

  // Add a custom exercise
  Future<void> addCustomExercise(String name) async {
    int newId = _builtInExercises.length + _customExercises.length;
    Map<String, Object> newExercise = {
      'id': newId,          // Integer ID
      'name': name,         // String name
      'modifiable': true,   // Boolean flag for modifiable
    };
    _customExercises.add(newExercise);
    await _saveCustomExercises(); // Save to SharedPreferences
  }

  bool checkIfCustom(String name){
    final foundExercise = allExercises.firstWhere(
          (exercise) => exercise['name'] == name && exercise['modifiable'] == true,
      orElse: () => {},
    );
    return foundExercise.isNotEmpty;
  }

  // Remove a custom exercise type if no exercise uses it
  Future<bool> removeCustomExercise(String name) async {
    // Check if exercises use this type
    List<Exercise> exercises = await ExercisesManager.eManager.exercises;
    bool typeInUse = exercises.any((exercise) => exercise.type == name);

    if (typeInUse) {
      print("Cannot delete: exercises exist with type $name.");
      return false;
    } else {
      // Remove from the custom exercises list
      _customExercises.removeWhere((exercise) => exercise['name'] == name);
      await _saveCustomExercises(); // Save changes
      return true;
    }
  }

  // Function to save custom exercises to SharedPreferences
  Future<void> _saveCustomExercises() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> customExerciseNames = _customExercises.map((exercise) => exercise['name'] as String).toList();
    await prefs.setStringList('customExercises', customExerciseNames);
  }

  // Function to load custom exercises from SharedPreferences
  Future<void> _loadCustomExercises() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? customExerciseNames = prefs.getStringList('customExercises');

    if (customExerciseNames != null) {
      _customExercises = customExerciseNames
          .asMap()
          .map((index, name) => MapEntry(index, {'id': _builtInExercises.length + index, 'name': name, 'modifiable': true}))
          .values
          .toList();
    }
  }
}
