import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_freak/Controllers/WorkoutController.dart';

import '../database_classes/Group.dart';
import '../database_classes/Workout.dart';

enum TrainingState {clean, e_before, e_during, e_after, e_summary, rating}


class TrainingManager{
  TrainingManager._privateConstructor();
  static final TrainingManager _tManager = TrainingManager._privateConstructor();
  static TrainingManager get tManager => _tManager;

  late Groups selectedGroup;
  late WorkoutController workoutController;
  late int exerciseNumber;
  late int series;

  final StreamController<TrainingState> _stateController = StreamController<TrainingState>.broadcast();

  TrainingState _actualState = TrainingState.clean;

  TrainingState get actualState => _actualState;

  set actualState(TrainingState newState) {
    _actualState = newState;
    _stateController.add(newState); // Emituje nowy stan
  }

  Stream<TrainingState> get stateStream => _stateController.stream;

  void dispose() {
    _stateController.close(); // Zamyka kontroler strumienia, gdy nie jest już potrzebny
  }

  Workout initiateWorkout(){
    DateTime dateTime = DateTime.now();
    DateTime dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return Workout.temporary(exercises: [], date: dateOnly);
  }

  void setOrResetData(Groups group){
    exerciseNumber = 0;
    series = 1;
    selectedGroup = group;
    workoutController = WorkoutController(initiateWorkout());
  }

  void nextSeries(){
    series += 1;
  }
  void nextExercise(){
      exerciseNumber += 1;
      series = 1;
  }

  // kod dla notyfikacji

  //


  // kod dla odliczania czasu

  //
}