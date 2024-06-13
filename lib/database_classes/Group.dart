import 'dart:convert';

import 'Exercise.dart';

class Groups {
  String name;
  List<Exercise> exercises;

  Groups({
    required this.name,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'exercises': jsonEncode(exercises.map((e) => e.toMap()).toList()), // Zapisujemy jako JSON
    };
  }

  factory Groups.fromMap(Map<String, dynamic> map) {
    return Groups(
      name: map['name'],
      exercises: List<Exercise>.from((jsonDecode(map['exercises']) as List).map((e) => Exercise.fromMap(e))),
    );
  }
}
