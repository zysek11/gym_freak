import 'dart:convert';
import 'Group.dart'; // Zakładam, że masz klasę Groups w tym pliku

class Exercise {
  final int? id;
  String name;
  String type;
  int application;
  String iconPath;
  String description;
  List<Groups>? groups; // Zmieniono na opcjonalne

  Exercise({
    this.id,
    required this.name,
    required this.type,
    required this.application,
    required this.iconPath,
    this.groups, // Pole opcjonalne
    required this.description,
  });

  // Serializacja (konwersja obiektu na mapę)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'application': application,
      'iconPath': iconPath,
      // Jeśli groups nie jest nullem, konwertuj na JSON, w przeciwnym razie zwróć pustą listę
      'groups': groups != null
          ? jsonEncode(groups!.map((group) => group.toMap()).toList())
          : jsonEncode([]),
      'description': description,
    };
  }

  // Deserializacja (konwersja mapy na obiekt)
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      application: map['application'] ?? 0,
      iconPath: map['iconPath'] ?? '',
      // Jeśli 'groupName' jest nullem lub pustą listą, zwróć null
      groups: map['groups'] != null && map['groups'].isNotEmpty
          ? List<Groups>.from(
          (jsonDecode(map['groups']) as List)
              .map((groupMap) => Groups.fromMap(groupMap)))
          : null,
      description: map['description'] ?? '',
    );
  }
}
