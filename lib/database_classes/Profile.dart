import 'dart:convert';

class Profile {
  String name;
  int age;
  double weight;
  double height;
  DateTime date;

  Profile({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'date': date.toIso8601String(),
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      name: map['name'],
      age: map['age'],
      weight: map['weight'],
      height: map['height'],
      date: DateTime.parse(map['date']),
    );
  }
}