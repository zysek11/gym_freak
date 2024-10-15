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

  void assignExercisesForSummary(List<Exercise> exercises) {
    selectedWorkout.exercises.clear(); // Czyszczenie listy, jeśli potrzebne
    for (var exercise in exercises) {
      selectedWorkout.exercises.add(ExerciseWrapper.full(
        exercise: exercise,
        series: 0,              // Przypisanie serii na 0
        weights: [],            // Pusta lista dla weights
        repetitions: [],        // Pusta lista dla repetitions
      ));
    }
  }


}


