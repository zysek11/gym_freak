class Measurement {
  final int? id;
  String name;
  double value;
  String unit;
  String date;
  int active;
  int profile_id; // Zmienna powiązana z Profile

  Measurement({
    this.id,
    required this.name,
    required this.value,
    required this.unit,
    required this.date,
    required this.active,
    required this.profile_id,
  });

  // Serializacja (konwersja obiektu na mapę)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'unit': unit,
      'date': date,
      'active': active,
      'profile_id': profile_id, // Powiązanie z Profile
    };
  }

  // Deserializacja (konwersja mapy na obiekt)
  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      id: map['id'],
      name: map['name'] ?? '',
      value: map['value'] ?? 0.0,
      unit: map['unit'] ?? '',
      date: map['date'] ?? '',
      active: map['active'] ?? 0,
      profile_id: map['profile_id'] ?? 0,
    );
  }
}
