import 'dart:convert';
import 'Exercise.dart';

class ExerciseWrapper {
  final int? id;
  Exercise exercise;
  int series;
  List<int>? weights; // Używamy opcjonalnych typów
  List<int>? repetitions; // Używamy opcjonalnych typów

  // Konstruktor Full - uwzględnia wszystkie właściwości
  ExerciseWrapper.full({
    this.id,
    required this.exercise,
    required this.series,
    required this.weights,
    required this.repetitions,
  });

  // Konstruktor Basic - ignoruje weights i repetitions
  ExerciseWrapper.basic({
    this.id,
    required this.exercise,
    required this.series,
  })  : weights = null,
        repetitions = null;

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'exercise': jsonEncode(exercise.toMap()),
      'series': series,
    };

    // Dodajemy weights i repetitions tylko, gdy nie są nullem
    if (weights != null) {
      map['weights'] = jsonEncode(weights);
    }
    if (repetitions != null) {
      map['repetitions'] = jsonEncode(repetitions);
    }

    return map;
  }

  factory ExerciseWrapper.fromMap(Map<String, dynamic> map) {
    return ExerciseWrapper.full(
      id: map['id'] ?? 0,
      exercise: Exercise.fromMap(jsonDecode(map['exercise'])),
      series: map['series'],
      weights: map.containsKey('weights') ? List<int>.from(jsonDecode(map['weights'])) : [], // Domyślnie pusta lista, jeśli null
      repetitions: map.containsKey('repetitions') ? List<int>.from(jsonDecode(map['repetitions'])) : [], // Domyślnie pusta lista, jeśli null
    );
  }
}
