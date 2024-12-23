import 'package:flutter/material.dart';
import 'quiz_question_navigate.dart'; // Assuming this is where MatchingGame is defined

class QuizSelectionScreen1 extends StatelessWidget {
  // Create a list of quiz numbers (no need for .json)
  final List<String> quizNumbers = List.generate(25, (index) => 'quiz${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Quiz'),
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
          itemCount: quizNumbers.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4, // Add shadow effect to the card
              margin: const EdgeInsets.symmetric(vertical: 8.0), // Space between cards
              child: ListTile(
                title: Text(
                  'Quiz ${index + 1}',
                  style: TextStyle(
                    fontSize: 18, // Font size for the quiz title
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2), // Match text color with question text color
                  ),
                ),
                tileColor: Colors.white, // Background color for the tile
                onTap: () {
                  // Navigate to MatchingGame with the appropriate quiz number (not file name)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchingGame(quizNumber: quizNumbers[index]), // Pass quiz number
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
