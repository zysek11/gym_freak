import 'dart:convert';
import 'Exercise.dart';

class ExerciseController {
  Exercise exercise;
  int series;
  List<int> weights;
  List<int> repetitions;

  ExerciseController({
    required this.exercise,
    required this.series,
    required this.weights,
    required this.repetitions,
  });

  Map<String, dynamic> toMap() {
    return {
      'exercise': jsonEncode(exercise.toMap()), // Zapisujemy jako JSON
      'series': series,
      'weights': jsonEncode(weights), // Zapisujemy jako JSON
      'repetitions': jsonEncode(repetitions), // Zapisujemy jako JSON
    };
  }

  factory ExerciseController.fromMap(Map<String, dynamic> map) {
    return ExerciseController(
      exercise: Exercise.fromMap(jsonDecode(map['exercise'])), // Odczytujemy z JSON
      series: map['series'],
      weights: List<int>.from(jsonDecode(map['weights'])), // Odczytujemy z JSON
      repetitions: List<int>.from(jsonDecode(map['repetitions'])), // Odczytujemy z JSON
    );
  }
}
