class Supplement {
  final int? id; // Nullable for auto-incrementing
  String name;
  double value;
  String unit;
  int indefiniteFlag; // Keeping as int for consistency
  String dateOfStart;
  String? dateOfEnd;
  int todayFlag; // Keeping as int for consistency
  int profileId;
  int checkCounterFlag; // Keeping as int for consistency
  int? counter;
  int? suppLimit;

  Supplement({
    this.id,
    required this.name,
    required this.value,
    required this.unit,
    required this.indefiniteFlag,
    required this.dateOfStart,
    required this.todayFlag,
    required this.profileId,
    required this.checkCounterFlag,
    this.dateOfEnd,
    this.counter,
    this.suppLimit,
  });

  // Convert to a map for SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'unit': unit,
      'indefinite': indefiniteFlag,
      'dateOfStart': dateOfStart,
      'dateOfEnd': dateOfEnd ?? '', // Default empty if null
      'today': todayFlag,
      'profile_id': profileId,
      'checkCounter': checkCounterFlag,
      'counter': counter ?? 0, // Default 0 if null
      'suppLimit': suppLimit ?? 0, // Default 0 if null
    };
  }

  // Convert from a map to create a Supplement object
  factory Supplement.fromMap(Map<String, dynamic> map) {
    return Supplement(
      id: map['id'],
      name: map['name'] ?? '',
      value: (map['value'] as num?)?.toDouble() ?? 0.0,
      unit: map['unit'] ?? '',
      indefiniteFlag: map['indefinite'] ?? 0,
      dateOfStart: map['dateOfStart'] ?? '',
      dateOfEnd: map['dateOfEnd'],
      todayFlag: map['today'] ?? 0,
      profileId: map['profile_id'] ?? 1,
      checkCounterFlag: map['checkCounter'] ?? 0,
      counter: map['counter'],
      suppLimit: map['suppLimit'],
    );
  }
}
