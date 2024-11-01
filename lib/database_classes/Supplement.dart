class Supplement {
  final int? id; // Nullable because it will be auto-incremented
  String name;
  double value; // The dosage or quantity of the supplement
  String unit; // Unit of measurement for the supplement
  String dateOfStart; // Start date of taking the supplement
  String dateOfEnd; // End date of taking the supplement
  int active; // A flag to check if the supplement is currently active
  int profileId; // Foreign key for the related Profile

  Supplement({
    this.id,
    required this.name,
    required this.value,
    required this.unit,
    required this.dateOfStart,
    required this.dateOfEnd,
    required this.active,
    required this.profileId,
  });

  // Serializing the object to a map, for inserting into the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'unit': unit,
      'dateOfStart': dateOfStart,
      'dateOfEnd': dateOfEnd,
      'active': active,
      'Profile_id': profileId, // Foreign key linking to Profile
    };
  }

  // Deserializing from a map to create a Supplement object
  factory Supplement.fromMap(Map<String, dynamic> map) {
    return Supplement(
      id: map['id'],
      name: map['name'] ?? '',
      value: map['value'] ?? 0.0,
      unit: map['unit'] ?? '',
      dateOfStart: map['dateOfStart'] ?? '',
      dateOfEnd: map['dateOfEnd'] ?? '',
      active: map['active'] ?? 0,
      profileId: map['Profile_id'] ?? 0,
    );
  }
}
