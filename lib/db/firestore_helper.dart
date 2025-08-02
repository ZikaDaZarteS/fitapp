import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout.dart';

class FirestoreHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addWorkout(Workout workout) async {
    await _db.collection('workouts').add({
      'title': workout.title,
      'category': workout.category,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateWorkout(Workout workout) async {
    if (workout.firestoreId == null) {
      throw Exception('ID do Firestore é nulo');
    }
    await _db.collection('workouts').doc(workout.firestoreId).update({
      'title': workout.title,
      'category': workout.category,
    });
  }

  Stream<List<Workout>> getWorkouts() {
    return _db
        .collection('workouts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Workout.fromFirestore(doc.id, doc.data());
          }).toList();
        });
  }

  Future<void> deleteWorkout(String firestoreId) async {
    await _db.collection('workouts').doc(firestoreId).delete();
  }
}
