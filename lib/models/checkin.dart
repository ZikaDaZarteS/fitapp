class Checkin {
  int? id; // SQLite
  String? firestoreId; // Firestore
  String userId;
  String note;
  String? imagePath;
  DateTime timestamp;

  Checkin({
    this.id,
    this.firestoreId,
    required this.userId,
    required this.note,
    this.imagePath,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'note': note,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Checkin.fromMap(Map<String, dynamic> map, {String? firestoreId}) {
    return Checkin(
      id: map['id'],
      firestoreId: firestoreId,
      userId: map['userId'] ?? '',
      note: map['note'] ?? '',
      imagePath: map['imagePath'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  factory Checkin.fromFirestore(String id, Map<String, dynamic> map) {
    return Checkin(
      firestoreId: id,
      userId: map['userId'] ?? '',
      note: map['note'] ?? '',
      imagePath: map['imagePath'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
