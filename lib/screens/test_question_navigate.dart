import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle to load the JSON file
import 'package:firebase_auth/firebase_auth.dart';
import 'result_screen.dart'; // Import the ResultScreen
import '../services/firestore_service.dart'; // Import the FirestoreService

class MatchingGame extends StatefulWidget {
  final String testName; // Receive the test name as a parameter

  const MatchingGame({Key? key, required this.testName}) : super(key: key);

  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  int score = 0; // Variable to keep track of the score
  Color? buttonAColor;
  Color? buttonBColor;
  Color? buttonCColor;
  Color? buttonDColor;
  final FirestoreService _firestoreService = FirestoreService(); // Create FirestoreService instance

  @override
  void initState() {
    super.initState();
    _loadQuestions(); // Load questions when the widget is created
  }

  // Function to load questions from the all_test.json file
  Future<void> _loadQuestions() async {
    try {
      final String response = await rootBundle.loadString('assets/all_test.json');
      final data = await json.decode(response);

      // Find the test that matches the testName provided in the constructor
      final test = data['tests'].firstWhere((test) => test['testName'] == widget.testName, orElse: () => null);

      if (test != null) {
        setState(() {
          questions = test['questions']; // Extract questions for the selected test
        });
      } else {
        // If no matching test is found, you can handle the error here
        print('Test not found');
      }
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  // Check the answer and update the score
  void checkAnswer(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        score++; // Increment the score if the answer is correct
      }

      // Reset button colors to avoid displaying red/green marks
      buttonAColor = null;
      buttonBColor = null;
      buttonCColor = null;
      buttonDColor = null;

      // Move to the next question automatically
      nextQuestion();
    });
  }

  // Go to the next question or navigate to the ResultScreen when finished
  void nextQuestion() {
    setState(() {
      // Check if there's a next question
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        // Save the score and completed tests to Firestore before navigating to ResultScreen
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          _firestoreService.updateUserScoreAndCompletedTests(user.uid, score, widget.testName);
        }

        // Navigate to the ResultScreen when all questions have been answered
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(score: score, totalQuestions: questions.length),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ); // Show a loading indicator while questions are being loaded
    }

    // Get the current question
    var currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('TEST'), // Display test name
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
                  currentQuestion['question'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2), // Darker purple for question text
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  currentQuestion['article'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800], // Dark grey for article text
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20), // Adjusted spacing
                // Answer buttons with a consistent style
                ElevatedButton(
                  onPressed: () => checkAnswer(currentQuestion['options'][0]['isCorrect']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonAColor ?? Colors.white,
                    minimumSize: Size(double.infinity, 50), // Increased height for buttons
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    currentQuestion['options'][0]['text'],
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => checkAnswer(currentQuestion['options'][1]['isCorrect']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBColor ?? Colors.white,
                    minimumSize: Size(double.infinity, 50), // Increased height for buttons
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    currentQuestion['options'][1]['text'],
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => checkAnswer(currentQuestion['options'][2]['isCorrect']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonCColor ?? Colors.white,
                    minimumSize: Size(double.infinity, 50), // Increased height for buttons
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    currentQuestion['options'][2]['text'],
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => checkAnswer(currentQuestion['options'][3]['isCorrect']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonDColor ?? Colors.white,
                    minimumSize: Size(double.infinity, 50), // Increased height for buttons
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    currentQuestion['options'][3]['text'],
                    style: const TextStyle(fontSize: 16, color: Colors.black),
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
