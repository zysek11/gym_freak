import 'dart:convert';
import 'Exercise.dart';

class ExerciseWrapper {
  final int? id;
  Exercise exercise;
  int series;
  List<double>? weights; // Używamy opcjonalnych typów
  List<int>? repetitions; // Używamy opcjonalnych typów
  DateTime date;
  late double powerCounter;

  // Konstruktor Full - uwzględnia wszystkie właściwości
  ExerciseWrapper.full({
    this.id,
    required this.exercise,
    required this.series,
    required this.weights,
    required this.repetitions,
    required this.date,
    this.powerCounter = 2.5,
  });

  // Konstruktor Basic - ignoruje weights i repetitions
  ExerciseWrapper.basic({
    this.id,
    required this.exercise,
    required this.series,
    required this.date,
  })  : weights = null,
        repetitions = null;

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'exercise': jsonEncode(exercise.toMap()),
      'series': series,
      'powerCounter': powerCounter,
      'date': date.toIso8601String(),
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
      powerCounter: map['powerCounter'],
      date: DateTime.parse(map['date']),
      weights: map.containsKey('weights') ? List<double>.from(jsonDecode(map['weights'])) : [], // Domyślnie pusta lista, jeśli null
      repetitions: map.containsKey('repetitions') ? List<int>.from(jsonDecode(map['repetitions'])) : [], // Domyślnie pusta lista, jeśli null
    );
  }
}
