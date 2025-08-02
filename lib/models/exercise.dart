class Exercise {
  int? id;
  int workoutId;
  String name;
  int sets;
  int reps;

  Exercise({
    this.id,
    required this.workoutId,
    required this.name,
    required this.sets,
    required this.reps,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'workoutId': workoutId,
      'name': name,
      'sets': sets,
      'reps': reps,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      workoutId: map['workoutId'],
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
    );
  }
}
