import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle to load the JSON file

class MatchingGame extends StatefulWidget {
  final String quizFileName; // Receive quiz file name as a parameter

  const MatchingGame({Key? key, required this.quizFileName}) : super(key: key);

  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
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
      final String response = await rootBundle.loadString('assets/${widget.quizFileName}');
      final data = await json.decode(response);
      setState(() {
        questions = data;
      });
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  // Check the answer and change button colors accordingly
  void checkAnswer(bool isCorrect, int buttonIndex) {
    setState(() {
      if (isCorrect) {
        if (buttonIndex == 0) {
          buttonAColor = Colors.green;
        } else if(buttonIndex == 1){
          buttonBColor = Colors.green;
        }else if(buttonIndex == 2){
          buttonCColor = Colors.green;
        }
        else{
          buttonDColor = Colors.green;
        }
      } else {
        if (buttonIndex == 0) {
          buttonAColor = Colors.red;
        } else if(buttonIndex == 1){
      buttonBColor = Colors.red;
      }else if(buttonIndex == 2){
      buttonCColor = Colors.red;
      }
      else{
      buttonDColor = Colors.red;
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
      buttonCColor = null;
      buttonDColor = null;

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
              onPressed: () => checkAnswer(currentQuestion['options'][0]['isCorrect'], 0),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonAColor, // Updated to backgroundColor
              ),
              child: Text(currentQuestion['options'][0]['text']),
            ),
            ElevatedButton(
              onPressed: () => checkAnswer(currentQuestion['options'][1]['isCorrect'], 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBColor, // Updated to backgroundColor
              ),
              child: Text(currentQuestion['options'][1]['text']),
            ),
            ElevatedButton(
              onPressed: () => checkAnswer(currentQuestion['options'][2]['isCorrect'], 2),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonCColor, // Updated to backgroundColor
              ),
              child: Text(currentQuestion['options'][2]['text']),
            ),
            ElevatedButton(
              onPressed: () => checkAnswer(currentQuestion['options'][3]['isCorrect'], 3),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonDColor, // Updated to backgroundColor
              ),
              child: Text(currentQuestion['options'][3]['text']),
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
