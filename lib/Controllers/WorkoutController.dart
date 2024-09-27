import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/Workout/During/WorkoutWidgets.dart';
import 'package:gym_freak/database_classes/Exercise.dart';

import '../Managers/TrainingManager.dart';
import '../database_classes/ExerciseWrapper.dart';
import '../database_classes/Group.dart';
import '../database_classes/Workout.dart';


class WorkoutController{

  late Workout selectedWorkout;
  late WidgetController widgetController = WidgetController();

  WorkoutController(this.selectedWorkout);

  void addExerciseToWorkout(Exercise e, int series, List<double> weights,
      List<int> repetitions){
    selectedWorkout.exercises.add(ExerciseWrapper.full(exercise: e, series: series,
    weights: weights, repetitions: repetitions));
  }

  void addExerciseToWorkoutBasic(Exercise e, int series){
    selectedWorkout.exercises.add(ExerciseWrapper.basic(exercise: e, series: series
        ));
  }

  Widget? loadWindow(TrainingState type){
    if(type == TrainingState.clean){
      widgetController.setActualWindow(widgetController.getCleanExercisesScreen());
      return widgetController.getActualWindow();
    }
    else if(type == TrainingState.e_pick){
      widgetController.setActualWindow(widgetController.getPickExerciseScreen());
      return widgetController.getActualWindow();
    }
    else if(type == TrainingState.e_before){
      widgetController.setActualWindow(widgetController.getBeforeExerciseScreen());
      return widgetController.getActualWindow();
    }
    else if(type == TrainingState.e_during){
      widgetController.setActualWindow(widgetController.getDuringExerciseScreen());
      return widgetController.getActualWindow();
    }
    else if(type == TrainingState.e_after){
      widgetController.setActualWindow(widgetController.getAfterExerciseScreen());
      return widgetController.getActualWindow();
    }
    else if(type == TrainingState.e_summary){
      widgetController.setActualWindow(widgetController.getSummaryExerciseScreen());
      return widgetController.getActualWindow();
    }
    else{
      widgetController.setActualWindow(widgetController.getRatingExercisesScreen());
      return widgetController.getActualWindow();
    }
  }
}


