import 'dart:convert';

import 'ExerciseController.dart';

class Workout {
  final int? id;
  late List<ExerciseController> exercises;
  DateTime date;
  int intensity;
  int satisfaction;
  String comment;
  Duration time;

  Workout({
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
    return Workout(
      id: map['id'] ?? 0,
      exercises: List<ExerciseController>.from((jsonDecode(map['exercises']) as List).map((e) => ExerciseController.fromMap(e))),
      date: DateTime.parse(map['date']),
      intensity: map['intensity'],
      satisfaction: map['satisfaction'],
      comment: map['comment'],
      time: Duration(seconds: map['time']),
    );
  }
}
