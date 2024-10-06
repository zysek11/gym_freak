import 'package:gym_freak/database_classes/Exercise.dart';
import '../database_classes/ExerciseWrapper.dart';
import '../database_classes/Workout.dart';


class WorkoutController{

  late Workout selectedWorkout;

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

}


