import 'package:flutter/material.dart';
import 'test_question_navigate.dart';

class TestSelectionScreen extends StatelessWidget {
  // Create a list of test file names for selection
  final List<String> testFileNames = List.generate(25, (index) => 'test${index + 1}.json');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Test'),
        backgroundColor: Color(0xFFB39DDB), // Match the AppBar color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.9), // Soft white
              Color(0xFFE1BEE7).withOpacity(0.8), // Lighter purple
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: testFileNames.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4, // Add shadow effect to the card
              margin: const EdgeInsets.symmetric(vertical: 8.0), // Space between cards
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              child: ListTile(
                title: Text(
                  'Test ${index + 1}',
                  style: TextStyle(
                    fontSize: 18, // Font size for the test title
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2), // Match text color with question text color
                  ),
                ),
                tileColor: Colors.white, // Background color for the tile
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchingGame(testFileName: testFileNames[index]), // Pass test file name
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
