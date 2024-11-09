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

  // Update the number of quizzes the user has attempted
  Future<void> updateQuizAttempts(String userId) async {
    try {
      DocumentReference userRef = _firestore.collection('Quiz').doc(userId);
      DocumentSnapshot userDoc = await userRef.get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;
        int attemptedQuizzes = data?['attempted_quizzes'] ?? 0;

        // Increment the number of quizzes attempted
        await userRef.update({
          'attempted_quizzes': attemptedQuizzes + 1,
        });
      } else {
        // If no user data, initialize with attempted_quizzes = 1
        await userRef.set({
          'attempted_quizzes': 1,
        });
      }
    } catch (e) {
      print("Error updating quiz attempts: $e");
    }
  }

  // Function to update the score and completed tests count for a user
  Future<void> updateUserScoreAndCompletedTests(String userId, int score, String testName) async {
    try {
      DocumentReference userRef = _firestore.collection('Test').doc(userId);

      // Fetch the user's data to update score and completed tests count
      DocumentSnapshot userDoc = await userRef.get();

      if (userDoc.exists) {
        // Retrieve the current values for the user's score and completed tests count
        int currentScore = userDoc['total_score'] ?? 0;
        int completedTests = userDoc['completed_tests'] ?? 0;

        // Calculate the new total score
        int newScore = currentScore + score;

        // Update the user's score and increment the number of completed tests
        await userRef.update({
          'total_score': newScore,
          'completed_tests': completedTests + 1,  // Increment completed tests count
          'last_completed_test': testName, // Optionally store the last completed test
        });

        print("User's score and completed tests updated successfully!");
      } else {
        // If the document does not exist, create a new document with the initial values
        await userRef.set({
          'total_score': score,
          'completed_tests': 1,  // This is the first test
          'last_completed_test': testName,
        });

        print("New user data created with score and completed tests!");
      }
    } catch (e) {
      print("Error updating user score and completed tests: $e");
    }
  }
}
