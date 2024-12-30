import 'dart:math';

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

  List<ExerciseWrapper> getExercisesByName(String name) {
    return _filteredExercisesW
        .where((exerciseWrapper) => exerciseWrapper.exercise.name == name)
        .toList();
  }

  int countWorkoutsOrSeriesWithExercise(String name, {bool series = false}){
    if (_filteredExercisesW.isEmpty) {
      return -1; // Zwracamy pustą listę, jeśli lista jest pusta
    }

    List<ExerciseWrapper> selectedExerciseGroup = getExercisesByName(name);

    int occ = 0;
    for(int i = 0; i < selectedExerciseGroup.length; i++){
        if(series){
          occ += (selectedExerciseGroup[i].series - 1);
        }
        else{
          occ++;
        }
    }
    return occ;
  }

  Map<String,double> calculatePowerPercentages() {
    if (_filteredExercisesW.isEmpty) {
      return {}; // Zwracamy pustą listę, jeśli lista jest pusta
    }

    final Map<String, List<ExerciseWrapper>> groupedExercises = {};
    for (int i = 0; i < _filteredExercisesW.length; i++) {
      if (_filteredExercisesW[i].exercise.application == 0) {
        continue;
      }
      groupedExercises.update(
        _filteredExercisesW[i].exercise.name,
            (existingList) => existingList..add(_filteredExercisesW[i]),
        ifAbsent: () => [_filteredExercisesW[i]],
      );
    }

    final Map<String,double> powerPercentages = {};


    groupedExercises.forEach((exerciseName, exerciseList) {
      if (exerciseList.length == 1) {
        // Jeśli w grupie jest tylko jeden element
        powerPercentages[exerciseName] = 9999;
        return;
      }

      ExerciseWrapper first = exerciseList.first;
      ExerciseWrapper last;

      // Jeśli jest więcej niż 6 elementów, wybieramy 6. element
      if (exerciseList.length > 6) {
        last = exerciseList[5];
      } else {
        last = exerciseList.last;
      }

      double lastPower = 0;
      double firstPower = 0;
      // dla 1
      for(int i = 0; i < first.series - 1; i++){
        double oneSeriesPower = first.weights![i] + (first.powerCounter * (first.repetitions![i] - 1));
        lastPower += oneSeriesPower;
      }
      lastPower /= first.series;

      // dla 2
      for(int i = 0; i < first.series - 1; i++){
        double oneSeriesPower = last.weights![i] + (last.powerCounter * (last.repetitions![i] - 1));
        firstPower += oneSeriesPower;
      }
      firstPower /= last.series;

      // Obliczenie różnicy procentowej
      double percentage = ((firstPower / lastPower) - 1) * 100;

      powerPercentages[exerciseName] = percentage;
    });

    return powerPercentages;

  }

  double calculateMaxPower(String name){
    List<ExerciseWrapper> selectedExerciseGroup = getExercisesByName(name);

    double calculate(int index){
      double firstPower = 0;
      ExerciseWrapper ew = selectedExerciseGroup[index];
      for(int i = 0; i < selectedExerciseGroup[i].series - 1; i++){
        double oneSeriesPower = ew.weights![i] + (ew.powerCounter * (ew.repetitions![i] - 1));
        firstPower += oneSeriesPower;
      }
      firstPower /= ew.series;
      return firstPower;
    }

    if(_filteredExercisesW.isEmpty){
      return -1;
    }

    double maxPower = 0;
    for(int i = 0; i < selectedExerciseGroup.length; i++){
      maxPower = calculate(i);
    }
    return maxPower;
  }

  double calculateMaxWeight(String name) {
    if(_filteredExercisesW.isEmpty){
      return -1;
    }

    List<ExerciseWrapper> selectedExerciseGroup = getExercisesByName(name);
    double maxWeight = 0;
    for(int i = 0; i < selectedExerciseGroup.length; i++){
      for(int j = 0; j < selectedExerciseGroup[i].series -1; j++){
        if(selectedExerciseGroup[i].repetitions?[j] == 1){
          maxWeight = max(maxWeight, selectedExerciseGroup[i].weights![j]);
        }
      }
    }
    return maxWeight;
  }

  double calculateMaxVolume(String name) {
    if(_filteredExercisesW.isEmpty){
      return -1;
    }

    List<ExerciseWrapper> selectedExerciseGroup = getExercisesByName(name);
    double maxVolume = 0;
    for(int i = 0; i < selectedExerciseGroup.length; i++){
      // wyliczanie
      double maxVol = 0;
      if(selectedExerciseGroup[i].exercise.name == name){
        for(int j = 0; j < selectedExerciseGroup[i].series -1; j++){
          maxVol += (selectedExerciseGroup[i].repetitions![j] * selectedExerciseGroup[i].weights![j])!;
        }
        maxVolume = max(maxVolume,maxVol);
      }
    }
    return maxVolume;
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
