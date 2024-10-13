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
          buttonAColor = Colors.green; // Green for correct answer
        } else if (buttonIndex == 1) {
          buttonBColor = Colors.green;
        } else if (buttonIndex == 2) {
          buttonCColor = Colors.green;
        } else {
          buttonDColor = Colors.green;
        }
      } else {
        if (buttonIndex == 0) {
          buttonAColor = Colors.red; // Red for incorrect
        } else if (buttonIndex == 1) {
          buttonBColor = Colors.red;
        } else if (buttonIndex == 2) {
          buttonCColor = Colors.red;
        } else {
          buttonDColor = Colors.red;
        }
      }
    });
  }

  // Go to the next question
  void nextQuestion() {
    setState(() {
      buttonAColor = null;
      buttonBColor = null;
      buttonCColor = null;
      buttonDColor = null;

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
      ); // Show a loading indicator while questions are being loaded
    }

    // Get the current question
    var currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matching Game'),
        backgroundColor: Color(0xFFB39DDB), // Light purple for AppBar
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
                // Use Flexible to prevent overflow
                Flexible(
                  child: Text(
                    currentQuestion['question'],
                    style: TextStyle(
                      fontSize: 18, // Further reduced font size for question text
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B1FA2), // Darker purple for question text
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible, // Allow overflow
                  ),
                ),
                SizedBox(height: 10),
                Flexible(
                  child: Text(
                    currentQuestion['article'],
                    style: TextStyle(
                      fontSize: 14, // Further reduced font size for article text
                      color: Colors.grey[800], // Dark grey for article text
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible, // Allow overflow
                  ),
                ),
                SizedBox(height: 20), // Adjusted spacing
                // Answer buttons with reduced height and font size
                ElevatedButton(
                  onPressed: () => checkAnswer(currentQuestion['options'][0]['isCorrect'], 0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonAColor ?? Colors.white,
                    minimumSize: Size(double.infinity, 35), // Further reduced height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    currentQuestion['options'][0]['text'],
                    style: const TextStyle(fontSize: 14, color: Colors.black), // Further reduced font size
                  ),
                ),
                SizedBox(height: 10), // Adjusted spacing
                ElevatedButton(
                  onPressed: () => checkAnswer(currentQuestion['options'][1]['isCorrect'], 1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBColor ?? Colors.white,
                    minimumSize: Size(double.infinity, 35), // Further reduced height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    currentQuestion['options'][1]['text'],
                    style: const TextStyle(fontSize: 14, color: Colors.black), // Further reduced font size
                  ),
                ),
                SizedBox(height: 10), // Adjusted spacing
                ElevatedButton(
                  onPressed: () => checkAnswer(currentQuestion['options'][2]['isCorrect'], 2),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonCColor ?? Colors.white,
                    minimumSize: Size(double.infinity, 35), // Further reduced height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    currentQuestion['options'][2]['text'],
                    style: const TextStyle(fontSize: 14, color: Colors.black), // Further reduced font size
                  ),
                ),
                SizedBox(height: 10), // Adjusted spacing
                ElevatedButton(
                  onPressed: () => checkAnswer(currentQuestion['options'][3]['isCorrect'], 3),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonDColor ?? Colors.white,
                    minimumSize: Size(double.infinity, 35), // Further reduced height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    currentQuestion['options'][3]['text'],
                    style: const TextStyle(fontSize: 14, color: Colors.black), // Further reduced font size
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB39DDB), // Light purple for Next Question button
                    minimumSize: Size(double.infinity, 35), // Further reduced height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Next Question',
                    style: TextStyle(fontSize: 14, color: Colors.white), // Further reduced font size
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
