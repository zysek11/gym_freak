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
    this.powerCounter = 0,
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
      id: map['id'] ?? 0, // Domyślnie 0, jeśli id jest null
      exercise: Exercise.fromMap(jsonDecode(map['exercise'])), // Rozpakowanie JSON na Exercise
      series: map['series'] ?? 0, // Domyślnie 0, jeśli series jest null
      powerCounter: map['powerCounter'] != null
          ? map['powerCounter'].toDouble()
          : 2.5, // Domyślnie 2.5, jeśli powerCounter jest null
      date: map['date'] != null
          ? DateTime.parse(map['date'])
          : DateTime.now(), // Domyślnie bieżąca data
      weights: map.containsKey('weights') && map['weights'] != null
          ? List<double>.from(jsonDecode(map['weights']))
          : [], // Domyślnie pusta lista
      repetitions: map.containsKey('repetitions') && map['repetitions'] != null
          ? List<int>.from(jsonDecode(map['repetitions']))
          : [], // Domyślnie pusta lista
    );
  }

}
