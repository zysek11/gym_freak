import 'dart:convert';
import 'ExerciseWrapper.dart';

abstract class Cloneable {
  Workout clone();
}

class Workout {
  final int? id;
  late List<ExerciseWrapper> exercises;
  DateTime date;
  late int intensity;
  late int satisfaction;
  late String comment;
  late Duration time;

  Workout.temporary({
    this.id,
    required this.exercises,
    required this.date,
  });

  Workout.full({
    this.id,
    required this.exercises,
    required this.date,
    required this.intensity,
    required this.satisfaction,
    required this.comment,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'exercises': jsonEncode(exercises.map((e) => e.toMap()).toList()), // Zapisujemy jako JSON
      'date': date.toIso8601String(),
      'intensity': intensity,
      'satisfaction': satisfaction,
      'comment': comment,
      'time': time.inSeconds,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout.full(
      id: map['id'] ?? 0,
      exercises: List<ExerciseWrapper>.from((jsonDecode(map['exercises']) as List).map((e) => ExerciseWrapper.fromMap(e))),
      date: DateTime.parse(map['date']),
      intensity: map['intensity'],
      satisfaction: map['satisfaction'],
      comment: map['comment'],
      time: Duration(seconds: map['time']),
    );
  }
}
