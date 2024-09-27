import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_freak/Controllers/WorkoutController.dart';

import '../database_classes/Exercise.dart';
import '../database_classes/Group.dart';
import '../database_classes/Workout.dart';

enum TrainingState {clean, e_pick, e_before, e_during, e_after, e_summary, rating}


class TrainingManager{
  TrainingManager._privateConstructor();
  static final TrainingManager _tManager = TrainingManager._privateConstructor();
  static TrainingManager get tManager => _tManager;

  late Groups selectedGroup;
  late WorkoutController workoutController;
  late int exerciseNumber;
  late int exerciseIdSelect;
  List<int> alreadySelected = [];
  late int series;
  late List<double> weights;
  late List<int> repeats;
  int _elapsedTime = 0;
  // sprawdza czy cwiczenie aktualne jest typu z ciezarkami czy bez
  bool exerciseClassicType = true;
  Timer? _timer;

  final StreamController<TrainingState> _stateController = StreamController<TrainingState>.broadcast();
  final StreamController<int> _timeController = StreamController<int>.broadcast();

  TrainingState _actualState = TrainingState.clean;

  TrainingState get actualState => _actualState;
  Stream<int> get timeStream => _timeController.stream;

  set actualState(TrainingState newState) {
    _actualState = newState;
    _stateController.add(newState); // Emituje nowy stan

    if (newState == TrainingState.e_during) {
      _startTimer();  // Uruchamia timer dla stanu e_during
    } else {
      _stopTimer();  // Zatrzymuje timer dla innych stanów
    }

  }

  Stream<TrainingState> get stateStream => _stateController.stream;

  void dispose() {
    _stateController.close(); // Zamyka kontroler strumienia, gdy nie jest już potrzebny
    _timeController.close();
    _stopTimer();
  }

  Workout initiateWorkout(){
    DateTime dateTime = DateTime.now();
    DateTime dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return Workout.temporary(exercises: [], date: dateOnly);
  }

  void setOrResetData(Groups group){
    exerciseNumber = 0;
    alreadySelected.clear();
    series = 1;
    weights = [];
    repeats = [];
    selectedGroup = group;
    workoutController = WorkoutController(initiateWorkout());
  }

  void setExercise(int id){
    exerciseIdSelect = id;
    alreadySelected.add(id);
    nextExercise();
  }

  void addSetData(double weight, int repeat){
    weights.add(weight);
    repeats.add(repeat);
  }
  void sendWorkoutData(Exercise exercise){
    exercise.application == 1 ? workoutController.addExerciseToWorkout(exercise, series, weights, repeats)
    : workoutController.addExerciseToWorkoutBasic(exercise, series);
  }

  void nextSeries(){
    series += 1;
  }
  void nextExercise(){
      exerciseNumber += 1;
      series = 1;
      weights = [];
      repeats = [];
  }

  // kod dla notyfikacji

  //


  // kod dla odliczania czasu
  void _startTimer() {
    _resetTimer();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedTime++;  // Zwiększa czas o 1 sekundę
      _timeController.add(_elapsedTime);  // Emituje nowy czas przez strumień
    });
  }

  void _stopTimer() {
    _timer?.cancel();  // Anuluje istniejący timer
  }

  void _resetTimer() {
    _stopTimer();  // Najpierw zatrzymuje timer
    _elapsedTime = 0;  // Resetuje czas
    _timeController.add(_elapsedTime);  // Emituje nowy czas przez strumień
  }

//
}