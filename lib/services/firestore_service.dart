// services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user information from 'userinfo' collection
  Future<Map<String, dynamic>?> getUserInfo(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('userinfo').doc(userId).get();
      return userDoc.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error fetching user info: $e");
      return null;
    }
  }

  Future<int?> getPuzzleGameProgress(String userId) async {
    try {
      DocumentSnapshot puzzleDoc = await _firestore.collection('puzzlegame').doc(userId).get();
      if (puzzleDoc.exists) {
        final data = puzzleDoc.data() as Map<String, dynamic>?;
        return data?['completed_levels'] as int? ?? 0; // Default to 0 if null or missing
      } else {
        print("Puzzle game data not found for userId: $userId");
        return 0; // Returning 0 if no data found for the user
      }
    } catch (e) {
      print("Error fetching puzzle game progress: $e");
      return null;
    }
  }

  // Fetch real-time puzzle game progress using a stream
  Stream<int?> getPuzzleGameProgressStream(String userId) {
    return _firestore.collection('puzzlegame')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        return data?['completed_levels'] as int? ?? 0;
      } else {
        return 0; // Return 0 if no data is found
      }
    });
  }

  // Fetch both user information and puzzle game progress together
  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      final userInfoSnapshot = await _firestore.collection('userinfo').doc(userId).get();
      final puzzleGameSnapshot = await _firestore.collection('puzzlegame-completed_levels').doc(userId).get();

      final userInfoData = userInfoSnapshot.data() as Map<String, dynamic>?;
      final puzzleGameData = puzzleGameSnapshot.data() as Map<String, dynamic>?;

      return {
        'name': userInfoData?['name'],
        'email': userInfoData?['email'],
        'dob': userInfoData?['dob'],
        'gender': userInfoData?['gender'],
        'puzzlegame_completed_levels': puzzleGameData?['completed_levels'] ?? 0,
      };
    } catch (e) {
      print("Error fetching combined user data: $e");
      return {};
    }
  }



}
