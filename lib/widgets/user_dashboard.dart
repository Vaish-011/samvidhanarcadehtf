import 'package:flutter/material.dart';
import '../services/firestore_service.dart';


class UserDashboardScreen extends StatelessWidget {
  final String userId;

  UserDashboardScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/b1.jpg',  // Adjust the path according to your project structure
              fit: BoxFit.cover,  // Ensures the image covers the entire screen
            ),
          ),

          // Content Layer
          SingleChildScrollView(  // Using SingleChildScrollView to allow scrolling of content
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<Map<String, dynamic>?>(
                future: FirestoreService().getUserInfo(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return Center(child: Text('Error fetching data'));
                  } else {
                    final userData = snapshot.data!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Photo or Default Human Icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            userData['photoUrl'] != null
                                ? CircleAvatar(
                              radius: 40,  // Increased size for profile image
                              backgroundImage: NetworkImage(userData['photoUrl']),
                            )
                                : CircleAvatar(
                              radius: 40,  // Increased size for default icon
                              backgroundColor: Colors.grey[300],
                              child: Icon(
                                Icons.person,
                                size: 40,  // Increased size for the icon
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        // User information
                        Text(
                          'Name: ${userData['name'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('Email: ${userData['email'] ?? 'N/A'}', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 5),
                        Text('DOB: ${userData['dob'] ?? 'N/A'}', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 5),
                        Text('Gender: ${userData['gender'] ?? 'N/A'}', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 20),

                        // Display the Crossword Game Badge Below Crossword Game Progress
                        StreamBuilder<int?>(
                          stream: FirestoreService().getCrosswordGameProgressStream(userId),
                          builder: (context, crosswordSnapshot) {
                            if (crosswordSnapshot.hasData && crosswordSnapshot.data! >= 5) {
                              return Center(
                                child: Image.asset(
                                  'assets/images/Badge.png',
                                  width: 80,  // Adjusted badge size
                                  height: 80,  // Adjusted badge size
                                ),
                              );
                            } else {
                              return Container();  // Hide badge if not enough progress
                            }
                          },
                        ),
                        SizedBox(height: 20),

                        // Puzzle Game Progress Section
                        Card(
                          color: Colors.teal[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: StreamBuilder<int?>(
                              stream: FirestoreService().getPuzzleGameProgressStream(userId),
                              builder: (context, puzzleSnapshot) {
                                if (puzzleSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (puzzleSnapshot.hasError || puzzleSnapshot.data == null) {
                                  return Text('Error fetching puzzle game progress');
                                } else {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Puzzle Game',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Bold and slightly larger font size
                                      ),
                                      SizedBox(height: 10),  // Adds spacing between the title and the progress text
                                      Text(
                                        'Puzzle Game Completed Levels: ${puzzleSnapshot.data ?? 0}',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Crossword Game Progress Section
                        Card(
                          color: Colors.teal[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: StreamBuilder<int?>(
                              stream: FirestoreService().getCrosswordGameProgressStream(userId),
                              builder: (context, crosswordSnapshot) {
                                if (crosswordSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (crosswordSnapshot.hasError || crosswordSnapshot.data == null) {
                                  return Text('Error fetching crossword game progress');
                                } else {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Crossword Game',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  // Bold and slightly larger font size
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Crossword Game Completed Levels: ${crosswordSnapshot.data ?? 0}',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Constitution Quest Progress Section
                        Card(
                          color: Colors.teal[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: StreamBuilder<Map<String, dynamic>>(
                              stream: FirestoreService().getUserProgressStream(userId),
                              builder: (context, progressSnapshot) {
                                if (progressSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (progressSnapshot.hasError || progressSnapshot.data == null) {
                                  return Text('Error fetching Constitution Quest progress');
                                } else {
                                  final progressData = progressSnapshot.data!;
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Constitution Quest',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Text('Completed Levels: ${progressData['completed_levels']}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                      SizedBox(height: 10),
                                      Text('Last Completed Level: ${progressData['last_level_completed']}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                      SizedBox(height: 10),
                                      Text('Coins: ${progressData['coins']}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                        // Add Test Data Section
                        SizedBox(height: 20),
                        Card(
                          color: Colors.teal[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FutureBuilder<Map<String, dynamic>?>(
                              future: FirestoreService().getTestData(userId),
                              builder: (context, testSnapshot) {
                                if (testSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (testSnapshot.hasError || testSnapshot.data == null) {
                                  return Text('Error fetching test data');
                                } else {
                                  final testData = testSnapshot.data!;
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Test',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Text('Total Score: ${testData['total_score'] ?? 0}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                      SizedBox(height: 10),
                                      Text('Completed Tests: ${testData['completed_tests'] ?? 0}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                      SizedBox(height: 10),
                                      Text('Last Completed Test: ${testData['last_completed_test'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                        // Add Quiz Data Section
                        SizedBox(height: 20),
                        Card(
                          color: Colors.teal[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: StreamBuilder<Map<String, dynamic>?>(
                              stream: FirestoreService().getQuizDataStream(userId),
                              builder: (context, quizSnapshot) {
                                if (quizSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (quizSnapshot.hasError || quizSnapshot.data == null) {
                                  return Text('Error fetching quiz data');
                                } else {
                                  final quizData = quizSnapshot.data!;
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quiz',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Text('Attempted Quizzes: ${quizData['attempted_quizzes'] ?? 0}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
