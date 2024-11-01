import 'dart:convert';

class Profile {
  final int? id;
  String name;
  int dob;

  Profile({
    this.id,
    required this.name,
    required this.dob
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'dob': dob
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] ?? 0,
      name: map['name'],
      dob: map['dob'],
    );
  }
}