import 'dart:convert';  // For json decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle to load the JSON file

class MatchingGame extends StatefulWidget {
  const MatchingGame({Key? key}) : super(key: key);

  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  Color? buttonAColor;
  Color? buttonBColor;

  @override
  void initState() {
    super.initState();
    _loadQuestions(); // Load questions when the widget is created
  }

  // Function to load the JSON file
  Future<void> _loadQuestions() async {
    final String response = await rootBundle.loadString('assets/questions.json');
    final data = await json.decode(response);
    setState(() {
      questions = data;
    });
  }

  // Check the answer and change button colors accordingly
  void checkAnswer(bool isCorrect, int buttonIndex) {
    setState(() {
      if (isCorrect) {
        if (buttonIndex == 0) {
          buttonAColor = Colors.green;
        } else {
          buttonBColor = Colors.green;
        }
      } else {
        if (buttonIndex == 0) {
          buttonAColor = Colors.red;
        } else {
          buttonBColor = Colors.red;
        }
      }
    });
  }

  // Go to the next question
  void nextQuestion() {
    setState(() {
      // Reset button colors
      buttonAColor = null;
      buttonBColor = null;

      // Check if there's a next question
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        // Show a dialog when all questions have been answered
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Quiz Completed'),
              content: const Text('You have answered all the questions!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      currentQuestionIndex = 0; // Restart the quiz
                    });
                  },
                  child: const Text('Restart'),
                ),
              ],
            );
          },
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
        title: const Text('Matching Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentQuestion['question']),
            Text(currentQuestion['article']),
            ElevatedButton(
              onPressed: () => checkAnswer(
                  currentQuestion['options'][0]['isCorrect'], 0),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonAColor, // Updated to backgroundColor
              ),
              child: Text(currentQuestion['options'][0]['text']),
            ),
            ElevatedButton(
              onPressed: () => checkAnswer(
                  currentQuestion['options'][1]['isCorrect'], 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBColor, // Updated to backgroundColor
              ),
              child: Text(currentQuestion['options'][1]['text']),
            ),
            ElevatedButton(
              onPressed: nextQuestion, // Call nextQuestion on press
              child: const Text('Next Question'),
            ),
          ],
        ),
      ),
    );
  }
}
