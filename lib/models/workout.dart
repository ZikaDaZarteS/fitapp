class Workout {
  int? id; // SQLite
  String? firestoreId; // Firestore
  String title;
  String? category;

  Workout({this.id, this.firestoreId, required this.title, this.category});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'category': category};
  }

  // Atenção: parâmetro opcional nomeado firestoreId
  factory Workout.fromMap(Map<String, dynamic> map, {String? firestoreId}) {
    return Workout(
      id: map['id'],
      firestoreId: firestoreId,
      title: map['title'] ?? '',
      category: map['category'],
    );
  }

  factory Workout.fromFirestore(String id, Map<String, dynamic> map) {
    return Workout(
      firestoreId: id,
      title: map['title'] ?? '',
      category: map['category'],
    );
  }
}
