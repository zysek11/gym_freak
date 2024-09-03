import 'package:flutter/cupertino.dart';

import '../database_classes/DatabaseHelper.dart';
import '../database_classes/Exercise.dart';

class ExercisesManager extends ChangeNotifier{
  ExercisesManager._privateConstructor();
  static final ExercisesManager _eManager = ExercisesManager._privateConstructor();
  static ExercisesManager get eManager => _eManager;

  Future<List<Exercise>> _exercises = Future.value([]);

  Future<List<Exercise>> get exercises {
    return _exercises;
  }

  void assignData(List<Exercise> ex) {
    _exercises = Future.value(ex);
    notifyListeners();
  }

  Future<void> initiateOrClearExercises(String? tecSearch) async {
    List<Exercise> exercises = await DatabaseHelper().getExercises();
    if (tecSearch != null && tecSearch.isNotEmpty) {
      filterExercises(tecSearch);
    } else {
      assignData(exercises);
    }
  }

  void sortExercises(String selectedOption) async {
    List<Exercise> exercises = await this.exercises;
    switch (selectedOption) {
      case "A-Z":
        exercises.sort((a, b) => a.name.compareTo(b.name));
        break;
      case "Z-A":
        exercises.sort((a, b) => b.name.compareTo(a.name));
        break;
      case "By type":
        exercises.sort((a, b) => a.type.compareTo(b.type));
        break;
    }
    assignData(exercises);
  }

  Future<void> filterExercises(String tecSearch) async {
    List<Exercise> exercises = await this.exercises;
    List<Exercise> filteredExercises = exercises.where((exercise) {
      return exercise.name.contains(tecSearch) ||
          exercise.groupName.any((group) => group.contains(tecSearch));
    }).toList();
    assignData(filteredExercises);
  }

  Future<void> removeExercise(int id) async {
    await DatabaseHelper().deleteExercise(id);
    initiateOrClearExercises(null);
  }
}
