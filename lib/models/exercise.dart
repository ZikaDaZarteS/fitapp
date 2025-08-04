class Exercise {
  final int? id;
  final String name;
  final String muscleGroup;
  final String description;
  final String instructions;
  final String? imageUrl;
  final String? videoUrl;
  final int? sets;
  final int? reps;
  final int? restTime; // em segundos
  final String? equipment;
  final String difficulty; // 'Iniciante', 'Intermediário', 'Avançado'

  Exercise({
    this.id,
    required this.name,
    required this.muscleGroup,
    required this.description,
    required this.instructions,
    this.imageUrl,
    this.videoUrl,
    this.sets,
    this.reps,
    this.restTime,
    this.equipment,
    this.difficulty = 'Intermediário',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'muscleGroup': muscleGroup,
      'description': description,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'sets': sets,
      'reps': reps,
      'restTime': restTime,
      'equipment': equipment,
      'difficulty': difficulty,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      muscleGroup: map['muscleGroup'],
      description: map['description'],
      instructions: map['instructions'],
      imageUrl: map['imageUrl'],
      videoUrl: map['videoUrl'],
      sets: map['sets'],
      reps: map['reps'],
      restTime: map['restTime'],
      equipment: map['equipment'],
      difficulty: map['difficulty'] ?? 'Intermediário',
    );
  }

  Exercise copyWith({
    int? id,
    String? name,
    String? muscleGroup,
    String? description,
    String? instructions,
    String? imageUrl,
    String? videoUrl,
    int? sets,
    int? reps,
    int? restTime,
    String? equipment,
    String? difficulty,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restTime: restTime ?? this.restTime,
      equipment: equipment ?? this.equipment,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
