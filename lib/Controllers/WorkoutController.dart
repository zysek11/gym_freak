import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/Workout/During/WorkoutWidgets.dart';

import '../Managers/TrainingManager.dart';
import '../database_classes/Group.dart';
import '../database_classes/Workout.dart';


class WorkoutController{

  late Workout selectedWorkout;
  late WidgetController widgetController = WidgetController();

  WorkoutController(this.selectedWorkout);

  Widget? loadWindow(TrainingState type){
    if(type == TrainingState.clean){
      widgetController.setActualWindow(widgetController.cleanExercises());
      return widgetController.getActualWindow();
    }
    else if(type == TrainingState.e_before){
      widgetController.setActualWindow(widgetController.beforeExercise());
      return widgetController.getActualWindow();
    }
    else if(type == TrainingState.e_during){
      widgetController.setActualWindow(widgetController.duringExercise());
      return widgetController.getActualWindow();
    }
    else if(type == TrainingState.e_after){
      widgetController.setActualWindow(widgetController.afterExercise());
      return widgetController.getActualWindow();
    }
    else if(type == TrainingState.e_summary){
      widgetController.setActualWindow(widgetController.summaryExercise());
      return widgetController.getActualWindow();
    }
    else{
      widgetController.setActualWindow(widgetController.ratingExercises());
      return widgetController.getActualWindow();
    }
  }
}


