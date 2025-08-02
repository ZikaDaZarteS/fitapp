class WorkoutPlan {
  int? id;
  String? firestoreId;
  String dayOfWeek;
  List<String> workoutTypes;
  String? notes;

  WorkoutPlan({
    this.id,
    this.firestoreId,
    required this.dayOfWeek,
    required this.workoutTypes,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayOfWeek': dayOfWeek,
      'workoutTypes': workoutTypes.join(','),
      'notes': notes,
    };
  }

  factory WorkoutPlan.fromMap(Map<String, dynamic> map, {String? firestoreId}) {
    return WorkoutPlan(
      id: map['id'],
      firestoreId: firestoreId,
      dayOfWeek: map['dayOfWeek'] ?? '',
      workoutTypes: (map['workoutTypes'] as String?)?.split(',') ?? [],
      notes: map['notes'],
    );
  }

  factory WorkoutPlan.fromFirestore(String id, Map<String, dynamic> map) {
    return WorkoutPlan(
      firestoreId: id,
      dayOfWeek: map['dayOfWeek'] ?? '',
      workoutTypes: (map['workoutTypes'] as String?)?.split(',') ?? [],
      notes: map['notes'],
    );
  }
}

class WorkoutType {
  static const List<String> types = [
    'Peito',
    'Costas',
    'Bíceps',
    'Tríceps',
    'Perna',
    'Ombro',
    'Abdômen',
  ];
}
