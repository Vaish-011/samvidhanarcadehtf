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


  // Fetch quiz data (attempted quizzes, score, etc.)
  Future<Map<String, dynamic>?> getQuizData(String userId) async {
    try {
      DocumentSnapshot quizDoc = await _firestore.collection('Quiz').doc(userId).get();
      if (quizDoc.exists) {
        return quizDoc.data() as Map<String, dynamic>?;
      } else {
        return {'attempted_quizzes': 0, 'latest_score': 0};  // Default if no data found
      }
    } catch (e) {
      print("Error fetching quiz data: $e");
      return null;
    }
  }

  // Fetch real-time quiz data using a stream
  Stream<Map<String, dynamic>?> getQuizDataStream(String userId) {
    return _firestore.collection('Quiz')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return {'attempted_quizzes': 0, 'latest_score': 0};
      }
    });
  }

// Fetch test data for a user
  Future<Map<String, dynamic>?> getTestData(String userId) async {
    try {
      DocumentSnapshot testDoc = await _firestore.collection('Test').doc(userId).get();
      if (testDoc.exists) {
        return testDoc.data() as Map<String, dynamic>?;
      } else {
        print("Test data not found for userId: $userId");
        return null; // Return null if no test data is found
      }
    } catch (e) {
      print("Error fetching test data: $e");
      return null;
    }
  }


  // Stream to listen for changes in test data for a user
  Stream<DocumentSnapshot> getTestDataStream(String userId) {
    try {
      // Return the stream of the document from Firestore
      return _firestore.collection('Test').doc(userId).snapshots();
    } catch (e) {
      print("Error fetching test data stream: $e");
      return Stream.empty();  // Return an empty stream in case of error
    }
  }



  Future<Map<String, dynamic>> getUserProgress(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('constitutionquest').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        return {
          'last_level_completed': data['last_level_completed'] ?? 0,
          'completed_levels': data['completed_levels'] ?? 0,
          'coins': data['coins'] ?? 0,
        };
      } else {
        return {
          'last_level_completed': 0,
          'completed_levels': 0,
          'coins': 0,
        };  // Default if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching user progress: $e");
      return {};  // Return an empty map if an error occurs
    }
  }


  Stream<Map<String, dynamic>> getUserProgressStream(String userId) {
    return _firestore.collection('constitutionquest')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return {
          'last_level_completed': data['last_level_completed'] ?? 0,
          'completed_levels': data['completed_levels'] ?? 0,
          'coins': data['coins'] ?? 0,
        };
      } else {
        return {
          'last_level_completed': 0,
          'completed_levels': 0,
          'coins': 0,
        };  // Default if the document doesn't exist
      }
    });
  }


  // Save level progress with last level completed, completed levels, and total coins
  Future<void> saveLevelProgress(String userId, int levelNumber, bool completed, int coins) async {
    try {
      DocumentReference userRef = _firestore.collection('constitutionquest').doc(userId);

      // Retrieve the current document to check the current data
      DocumentSnapshot userDoc = await userRef.get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;

        // Initialize values if they don't exist yet
        int currentCompletedLevels = data?['completed_levels'] ?? 0;
        int totalCoins = data?['coins'] ?? 0;
        int lastLevelCompleted = data?['last_level_completed'] ?? 0;

        // Update completed levels if the current level is completed
        if (completed && levelNumber > lastLevelCompleted) {
          lastLevelCompleted = levelNumber;
          currentCompletedLevels++;
          totalCoins += coins;  // Add coins to total coins
        }

        // Update the user's progress in the Firestore document
        await userRef.set({
          'last_level_completed': lastLevelCompleted,
          'completed_levels': currentCompletedLevels,
          'coins': totalCoins,
        }, SetOptions(merge: true));
      } else {
        // If the document doesn't exist, initialize the user with level 1 data
        await userRef.set({
          'last_level_completed': completed ? levelNumber : 0,
          'completed_levels': completed ? 1 : 0,
          'coins': completed ? coins : 0,
        });
      }

    } catch (e) {
      print("Error saving level progress: $e");
    }
  }


  // Update the total coins for the user in the 'constitutionquest' document
  Future<void> _updateTotalCoins(String userId) async {
    try {
      final userRef = _firestore.collection('constitutionquest').doc(userId);
      final userDoc = await userRef.get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        int totalCoins = 0;

        // Sum up coins from all levels directly in the 'constitutionquest' document
        data.forEach((key, value) {
          if (key.startsWith('level_')) {
            totalCoins += (value['coins'] ?? 0) as int;
          }
        });

        // Update total coins for the user
        await userRef.update({'total_coins': totalCoins});
      } else {
        print("User document does not exist.");
      }
    } catch (e) {
      print("Error updating total coins: $e");
    }
  }

  // Fetch the level progress and coins for a user from 'constitutionquest' collection
  Future<Map<String, dynamic>> getLevelProgress(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('constitutionquest').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        Map<String, dynamic> levels = {};

        // Fetch the progress of each level from the user's document
        data.forEach((key, value) {
          if (key.startsWith('level_')) {
            levels[key] = value;
          }
        });
        return levels;
      }
      return {};
    } catch (e) {
      print("Error fetching level progress: $e");
      return {};
    }
  }

  // Fetch the total coins directly from the 'constitutionquest' document
  Future<int> getTotalCoins(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('constitutionquest').doc(userId).get();
      if (userDoc.exists) {
        return userDoc['total_coins'] ?? 0;
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
  // Fetch crossword game progress from the 'users' collection
  Future<int?> getCrosswordGameProgress(String userId) async {
    try {
      DocumentSnapshot crosswordDoc = await _firestore.collection('users').doc(userId).get();
      if (crosswordDoc.exists) {
        final data = crosswordDoc.data() as Map<String, dynamic>?;
        return data?['completed_levels'] as int? ?? 0; // Default to 0 if no completed levels
      } else {
        print("Crossword game data not found for userId: $userId");
        return 0; // Return 0 if no crossword game data is found for the user
      }
    } catch (e) {
      print("Error fetching crossword game progress: $e");
      return null;
    }
  }

  // Fetch real-time crossword game progress using a stream from the 'users' collection
  Stream<int?> getCrosswordGameProgressStream(String userId) {
    return _firestore.collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        return data?['completed_levels'] as int? ?? 0; // Default to 0 if no completed levels
      } else {
        return 0; // Return 0 if no data found
      }
    });
  }
}