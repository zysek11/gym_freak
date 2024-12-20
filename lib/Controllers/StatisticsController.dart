import 'package:flutter/material.dart';
import '../database_classes/DatabaseHelper.dart';
import '../database_classes/ExerciseWrapper.dart';
import '../database_classes/Workout.dart';

class StatisticsController extends ChangeNotifier {
  StatisticsController._privateConstructor();
  static final StatisticsController _statsManager = StatisticsController._privateConstructor();
  static StatisticsController get statsManager => _statsManager;

  List<Workout> _workouts = [];
  List<Workout> _filteredWorkouts = []; // Dodano do filtrowania
  List<ExerciseWrapper> _exercisesW = [];
  List<ExerciseWrapper> _filteredExercisesW = [];

  List<Workout> get workouts => _filteredWorkouts.isNotEmpty ? _filteredWorkouts : _workouts;

  List<ExerciseWrapper> get exercises => _filteredExercisesW;

  Future<void> getWorkouts() async {
    _workouts = await DatabaseHelper().getWorkouts();
    sortWorkoutsByDate();
    _filteredWorkouts = []; // Resetuje listę filtrowaną
    notifyListeners();
  }

  Future<void> getExercises() async {
    _exercisesW = await DatabaseHelper().getExerciseControllers();
    if(_exercisesW.isNotEmpty){
      sortExercisesByType();
    }
  }

  //Sortuje listę _exercisesW według pola exercise.type.
  // [alphabetically] określa, czy sortowanie ma być alfabetyczne (domyślnie true).
  void sortExercisesByType({bool alphabetically = true, List<String>? customOrder}) {
    if (alphabetically) {
      _filteredExercisesW = _exercisesW..sort((a, b) => a.exercise.type.compareTo(b.exercise.type));
    } else if (customOrder != null) {
      // Sortowanie na podstawie kolejności w customOrder
      final orderMap = {for (var i = 0; i < customOrder.length; i++) customOrder[i]: i};
      _filteredExercisesW = _exercisesW
        ..sort((a, b) {
          final indexA = orderMap[a.exercise.type] ?? customOrder.length;
          final indexB = orderMap[b.exercise.type] ?? customOrder.length;
          return indexA.compareTo(indexB);
        });
    }
    notifyListeners();
  }


  void sortWorkoutsByDate({bool descending = true}) {
    _workouts.sort((a, b) {
      final dateA = DateTime.parse(a.date.toString()); // Zakładamy, że a.date to string w formacie ISO8601
      final dateB = DateTime.parse(b.date.toString());
      return descending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });
    notifyListeners(); // Powiadamia o zmianie stanu
  }



  Future<void> addWorkout(Workout workout) async {
    await DatabaseHelper().insertWorkout(workout);
    await DatabaseHelper().insertExerciseControllers(workout.exercises);
    await getWorkouts(); // Refresh list after adding
    await getExercises();
  }

  Future<void> updateWorkout(Workout workout) async {
    await DatabaseHelper().updateWorkout(workout);
    final index = _workouts.indexWhere((s) => s.id == workout.id);
    if (index != -1) {
      _workouts[index] = workout;
      notifyListeners(); // Trigger update
      print("Updated workout id: ${_workouts[index].id}"); // Debugging line
    }
  }

  Future<void> removeWorkout(int id, bool sortType) async {
    await DatabaseHelper().deleteWorkout(id);
    await getWorkouts(); // Refresh list after removal
    sortWorkoutsByDate(descending: sortType);
  }

  /// **Funkcja filtrowania po nazwie**
  void filterWorkoutsByName(String query) {
    if (query.isEmpty) {
      _filteredWorkouts = [];
    } else {
      _filteredWorkouts = _workouts
          .where((workout) => workout.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

}
