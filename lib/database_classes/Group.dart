import 'dart:convert';

import 'Exercise.dart';

class Groups {
  final int? id;
  String name;
  String iconPath;
  List<Exercise> exercises;

  Groups({
    this.id,
    required this.name,
    required this.iconPath,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'iconPath': iconPath,
      'exercises': jsonEncode(exercises.map((e) => e.toMap()).toList()), // Zapisujemy jako JSON
    };
  }

  factory Groups.fromMap(Map<String, dynamic> map) {
    return Groups(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      iconPath: map['iconPath'] ?? '',
      exercises: List<Exercise>.from((jsonDecode(map['exercises']) as List).map((e) => Exercise.fromMap(e))),
    );
  }
}
