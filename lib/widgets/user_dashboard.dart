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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>?>(  // Fetch user data
          future: FirestoreService().getUserInfo(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('Error fetching data'));
            } else {
              final userData = snapshot.data!;

              return ListView(
                children: [
                  // Profile Photo or Default Human Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile picture or default human icon
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
                            return Text(
                              'Puzzle Game Completed Levels: ${puzzleSnapshot.data ?? 0}',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                            return Text(
                              'Crossword Game Completed Levels: ${crosswordSnapshot.data ?? 0}',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            );
                          }
                        },
                      ),
                    ),
                  ),

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
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
