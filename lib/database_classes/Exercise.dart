import 'dart:convert';

class Exercise {
  final int? id;
  String name;
  String type;
  int application;
  String iconPath;
  List<String> groupName;
  String description;

  Exercise({
    this.id,
    required this.name,
    required this.type,
    required this.application,
    required this.iconPath,
    required this.groupName,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'type': type,
      'application': application,
      'iconPath': iconPath,
      'groupName': jsonEncode(groupName), // Zapisujemy jako JSON
      'description': description,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      application: map['application'] ?? 0,
      iconPath: map['iconPath'] ?? '',
      groupName: List<String>.from(jsonDecode(map['groupName'] ?? '[]')),
      description: map['description'] ?? '',
    );
  }
}