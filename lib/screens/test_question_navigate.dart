import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle to load the JSON file
import 'result_screen.dart'; // Import the ResultScreen

class MatchingGame extends StatefulWidget {
  final String testFileName; // Receive quiz file name as a parameter

  const MatchingGame({Key? key, required this.testFileName}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _loadQuestions(); // Load questions when the widget is created
  }

  // Function to load the JSON file
  Future<void> _loadQuestions() async {
    try {
      // Use widget.quizFileName to load the specific quiz file
      final String response = await rootBundle.loadString('assets/${widget.testFileName}');
      final data = await json.decode(response);
      setState(() {
        questions = data;
      });
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

  // Go to the next question
  void nextQuestion() {
    setState(() {
      // Check if there's a next question
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
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
        title: const Text('Test Game'), // Change the title here
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentQuestion['question']),
            Text(currentQuestion['article']),
            ElevatedButton(
              onPressed: () => checkAnswer(currentQuestion['options'][0]['isCorrect']),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonAColor, // Updated to backgroundColor
              ),
              child: Text(currentQuestion['options'][0]['text']),
            ),
            ElevatedButton(
              onPressed: () => checkAnswer(currentQuestion['options'][1]['isCorrect']),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBColor, // Updated to backgroundColor
              ),
              child: Text(currentQuestion['options'][1]['text']),
            ),
            ElevatedButton(
              onPressed: () => checkAnswer(currentQuestion['options'][2]['isCorrect']),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonCColor, // Updated to backgroundColor
              ),
              child: Text(currentQuestion['options'][2]['text']),
            ),
            ElevatedButton(
              onPressed: () => checkAnswer(currentQuestion['options'][3]['isCorrect']),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonDColor, // Updated to backgroundColor
              ),
              child: Text(currentQuestion['options'][3]['text']),
            ),
            // Removed the Next Question button
          ],
        ),
      ),
    );
  }
}
