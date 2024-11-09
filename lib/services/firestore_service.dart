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

  // Save progress for a particular level, including coins earned
  Future<void> saveLevelProgress(String userId, int levelNumber, bool completed, int coins) async {
    try {
      DocumentReference userRef = _firestore.collection('constitutionquest').doc(userId);

      // Update level completion and coins for the specific level
      await userRef.collection('levels').doc('level$levelNumber').set({
        'completed': completed,
        'coins': coins,
      }, SetOptions(merge: true));

      // Optionally, update total coins for the user
      await _updateTotalCoins(userId);
    } catch (e) {
      print("Error saving level progress: $e");
    }
  }

  // Update the total coins for the user based on the levels they completed
  Future<void> _updateTotalCoins(String userId) async {
    try {
      final userRef = _firestore.collection('constitutionquest').doc(userId);
      final levelsSnapshot = await userRef.collection('levels').get();

      int totalCoins = 0;
      for (var levelDoc in levelsSnapshot.docs) {
        totalCoins += (levelDoc['coins'] as num).toInt();
      }

      // Update total coins for the user
      await userRef.update({'total_coins': totalCoins});
    } catch (e) {
      print("Error updating total coins: $e");
    }
  }

  // Fetch the level progress and coins for a user
  Future<Map<String, dynamic>> getLevelProgress(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('constitutionquest').doc(userId).get();
      if (userDoc.exists) {
        final levelsSnapshot = await userDoc.reference.collection('levels').get();
        Map<String, dynamic> levels = {};

        for (var levelDoc in levelsSnapshot.docs) {
          levels[levelDoc.id] = {
            'completed': levelDoc['completed'],
            'coins': levelDoc['coins'],
          };
        }
        return levels;
      }
      return {};
    } catch (e) {
      print("Error fetching level progress: $e");
      return {};
    }
  }

  // Fetch the user's total coins
  Future<int> getTotalCoins(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('constitutionquest').doc(userId).get();
      if (userDoc.exists) {
        final totalCoins = userDoc['total_coins'] ?? 0;
        return totalCoins;
      } else {
        return 0;
      }
    } catch (e) {
      print("Error fetching total coins: $e");
      return 0;
    }
  }
}
