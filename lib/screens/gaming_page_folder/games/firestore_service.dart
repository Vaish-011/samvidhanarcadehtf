import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User collection methods
  Future<void> updateCompletedLevels(String userId, int completedLevels) async {
    await _db.collection('users').doc(userId).set({
      'completed_levels': completedLevels,
    }, SetOptions(merge: true)); // Use merge to avoid overwriting other fields
  }

  Future<int> getCompletedLevels(String userId) async {
    DocumentSnapshot snapshot = await _db.collection('users').doc(userId).get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>?;
      return data?['completed_levels'] ?? 0;
    }
    return 0; // Default value if not found
  }

  // Puzzle game collection methods
  Future<void> updatePuzzleGameLevels(String userId, int completedLevels) async {
    await _db.collection('puzzlegame').doc(userId).set({
      'completed_levels': completedLevels,
    }, SetOptions(merge: true)); // Use merge to avoid overwriting other fields
  }

  Future<int> getPuzzleGameLevels(String userId) async {
    DocumentSnapshot snapshot = await _db.collection('puzzlegame').doc(userId).get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>?;
      return data?['completed_levels'] ?? 0;
    }
    return 0; // Default value if not found
  }
}
