import 'dart:convert'; // For json decoding
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

  Future<void> _loadQuestions() async {
    final String response = await rootBundle.loadString('assets/questions.json');
    final data = await json.decode(response);
    setState(() {
      questions = data;
    });
  }

  void checkAnswer(bool isCorrect, int buttonIndex) {
    setState(() {
      if (isCorrect) {
        if (buttonIndex == 0) {
          buttonAColor = Colors.green; // Green for correct
        } else {
          buttonBColor = Colors.green; // Green for correct
        }
      } else {
        if (buttonIndex == 0) {
          buttonAColor = Colors.redAccent; // Red for incorrect
        } else {
          buttonBColor = Colors.redAccent;
        }
      }
    });
  }

  void nextQuestion() {
    setState(() {
      buttonAColor = null;
      buttonBColor = null;

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
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
      );
    }

    var currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matching Game'),
        backgroundColor: Color(0xFFB39DDB), // Light purple color for AppBar
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
                // Question text
                Text(
                  currentQuestion['question'],
                  style: TextStyle(
                    fontSize: 20, // Decreased font size
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2), // Darker purple for question text
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  currentQuestion['article'],
                  style: TextStyle(
                    fontSize: 14, // Decreased font size
                    color: Colors.grey[800], // Dark grey for article text
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                // Answer buttons
                _buildAnswerButton(
                  text: currentQuestion['options'][0]['text'],
                  isCorrect: currentQuestion['options'][0]['isCorrect'],
                  buttonIndex: 0,
                ),
                SizedBox(height: 15),
                _buildAnswerButton(
                  text: currentQuestion['options'][1]['text'],
                  isCorrect: currentQuestion['options'][1]['isCorrect'],
                  buttonIndex: 1,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB39DDB), // Light purple for Next Question button
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Next Question',
                    style: TextStyle(fontSize: 18, color: Colors.white), // White text for visibility
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildAnswerButton({
    required String text,
    required bool isCorrect,
    required int buttonIndex,
  }) {
    Color buttonColor = (buttonIndex == 0 ? buttonAColor : buttonBColor) ?? Colors.white; // Default to white if no color
    double fontSize = buttonColor == Colors.green ? 16 : 14; // Decrease font size for incorrect answers

    return ElevatedButton(
      onPressed: () => checkAnswer(isCorrect, buttonIndex),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: Colors.black), // Adjust font size based on answer correctness
      ),
    );
  }
}
