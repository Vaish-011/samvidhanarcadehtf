import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  ResultScreen({required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Result'),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TEST COMPLETED!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2), // Darker purple for title
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'You scored $score out of $totalQuestions!',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey[800], // Dark grey for score text
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Return to the home screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB39DDB), // Light purple for button
                    minimumSize: Size(double.infinity, 50), // Button height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Back to HOME',
                    style: TextStyle(fontSize: 16, color: Colors.white), // White text for button
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
