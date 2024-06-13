import 'dart:convert';

class Exercise {
  String name;
  int type;
  String iconPath;
  List<String> group;
  String description;

  Exercise({
    required this.name,
    required this.type,
    required this.iconPath,
    required this.group,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'iconPath': iconPath,
      'group': jsonEncode(group), // Zapisujemy jako JSON
      'description': description,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'],
      type: map['type'],
      iconPath: map['iconPath'],
      group: List<String>.from(jsonDecode(map['group'])), // Odczytujemy z JSON
      description: map['description'],
    );
  }
}