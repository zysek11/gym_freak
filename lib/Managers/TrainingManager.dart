import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_freak/Controllers/WorkoutController.dart';

import '../database_classes/Exercise.dart';
import '../database_classes/Group.dart';
import '../database_classes/Workout.dart';



class TrainingManager {
  TrainingManager._privateConstructor();
  static final TrainingManager _tManager = TrainingManager._privateConstructor();
  static TrainingManager get tManager => _tManager;

  late Groups selectedGroup;
  WorkoutController? workoutController;
  late int exerciseNumber;
  late int exerciseIdSelect;
  List<int> alreadySelected = [];
  late int series;
  late List<double> weights;
  late List<int> repeats;

  // Timer dla poszczególnych ćwiczeń
  int _elapsedTime = 0;
  Timer? _timer;

  bool breakTimerOn = false;
  int _breakElapsedTime = 0;
  Timer? _breakTimer;

  // Globalny timer dla całego treningu
  int _elapsedGlobalTime = 0;
  Timer? _globalTimer;

  StreamController<int> _timeController = StreamController<int>.broadcast();
  StreamController<int> _breakTimeController = StreamController<int>.broadcast();
  StreamController<int> _globalTimeController = StreamController<int>.broadcast(); // Globalny stream

  Stream<int> get timeStream => _timeController.stream;
  Stream<int> get breakTimeStream => _breakTimeController.stream;
  Stream<int> get globalTimeStream => _globalTimeController.stream; // Globalny stream

  Duration returnFullTime(){
    return Duration(seconds: _elapsedGlobalTime);
  }

  Duration returnBreakTime(){
    return Duration(seconds: _breakElapsedTime);
  }

  void dispose() {
    _timeController.close();
    _breakTimeController.close();
    _globalTimeController.close(); // Zamknięcie streamu globalnego
    stopTimer();
    stopBreakTimer();
    stopGlobalTimer(); // Zatrzymanie globalnego timera
  }

  void cleanData(){
    exerciseNumber = 0;
    alreadySelected.clear();
    series = 1;
    weights = [];
    repeats = [];
    workoutController = null;
  }

  Workout initiateWorkout() {
    DateTime dateTime = DateTime.now();
    DateTime dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return Workout.temporary(exercises: [], date: dateOnly);
  }

  void setOrResetData(Groups group) {
    exerciseNumber = 0;
    alreadySelected.clear();
    series = 1;
    weights = [];
    repeats = [];
    selectedGroup = group;
    workoutController = WorkoutController(initiateWorkout());
    _timeController = StreamController<int>.broadcast();
    _breakTimeController = StreamController<int>.broadcast();
    _globalTimeController = StreamController<int>.broadcast();
  }

  void setExercise(int id) {
    exerciseIdSelect = id;
  }

  void short_assignForSummary(){
    workoutController?.assignExercisesForSummary(selectedGroup.exercises);
  }

  void addSetData(double weight, int repeat) {
    weights.add(weight);
    repeats.add(repeat);
  }

  void sendWorkoutData(Exercise exercise) {
    exercise.application == 1
        ? workoutController!.addExerciseToWorkout(exercise, series, weights, repeats)
        : workoutController!.addExerciseToWorkoutBasic(exercise, series);
    alreadySelected.add(exerciseIdSelect);
    nextExercise();
  }

  void sendSkipData(){
    alreadySelected.add(exerciseIdSelect);
    nextExercise();
  }

  void nextSeries() {
    series += 1;
  }

  void nextExercise() {
    exerciseNumber += 1;
    series = 1;
    weights = [];
    repeats = [];
  }

  void checkUndoSeries() {
    if (series > 1) {
      series -= 1;
      weights.removeLast();
      repeats.removeLast();
    }
  }

  // Kod dla odliczania czasu poszczególnych ćwiczeń
  void startTimer() {
    resetTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedTime++;  // Zwiększa czas o 1 sekundę
      _timeController.add(_elapsedTime);  // Emituje nowy czas przez strumień
    });
  }

  void stopTimer() {
    _timer?.cancel();  // Anuluje istniejący timer
  }

  void resetTimer() {
    stopTimer();  // Najpierw zatrzymuje timer
    _elapsedTime = 0;  // Resetuje czas
    _timeController.add(_elapsedTime);  // Emituje nowy czas przez strumień
  }

  // Kod dla odliczania czasu poszczególnych ćwiczeń
  void startBreakTimer() {
    if(breakTimerOn){
      resetBreakTimer();
      _breakTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        _breakElapsedTime++;  // Zwiększa czas o 1 sekundę
        _breakTimeController.add(_breakElapsedTime);  // Emituje nowy czas przez strumień
      });
    }
  }

  void stopBreakTimer() {
    _breakTimer?.cancel();  // Anuluje istniejący timer
  }

  void resetBreakTimer() {
    stopBreakTimer();  // Najpierw zatrzymuje timer
    _breakElapsedTime = 0;  // Resetuje czas
    _breakTimeController.add(_breakElapsedTime);  // Emituje nowy czas przez strumień
  }

  // Kod dla globalnego timera całego treningu
  void startGlobalTimer() {
    resetGlobalTimer();
    _globalTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedGlobalTime++;  // Zwiększa globalny czas o 1 sekundę
      _globalTimeController.add(_elapsedGlobalTime);  // Emituje nowy globalny czas przez strumień
    });
  }

  void stopGlobalTimer() {
    _globalTimer?.cancel();  // Anuluje istniejący globalny timer
  }

  void resetGlobalTimer() {
    stopGlobalTimer();  // Najpierw zatrzymuje globalny timer
    _elapsedGlobalTime = 0;  // Resetuje globalny czas
    _globalTimeController.add(_elapsedGlobalTime);  // Emituje nowy globalny czas przez strumień
  }
}
