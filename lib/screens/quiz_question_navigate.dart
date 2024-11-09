import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle to load the JSON file

class MatchingGame extends StatefulWidget {
  final String quizNumber; // Pass the quiz number (quiz1, quiz2, quiz3)

  const MatchingGame({Key? key, required this.quizNumber}) : super(key: key);

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

  // Function to load the correct quiz from the combined JSON file
  Future<void> _loadQuestions() async {
    try {
      final String response = await rootBundle.loadString('assets/all_quizzes.json');
      final data = json.decode(response); // Decode the whole JSON

      // Debugging: Print the loaded JSON data
      print('Loaded JSON data: $data');

      // Check if the quiz number exists in the JSON structure
      if (data[widget.quizNumber] != null) {
        setState(() {
          questions = data[widget.quizNumber];
        });
        print('Questions loaded: ${questions.length} questions available.');
      } else {
        print('Quiz not found: ${widget.quizNumber}');
        // Optionally, show an error dialog or notification
      }
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  // Check the answer and change button colors accordingly
  void checkAnswer(bool isCorrect, int buttonIndex) {
    setState(() {
      if (isCorrect) {
        // Set color to green if answer is correct
        if (buttonIndex == 0) {
          buttonAColor = Colors.green;
        } else if (buttonIndex == 1) {
          buttonBColor = Colors.green;
        } else if (buttonIndex == 2) {
          buttonCColor = Colors.green;
        } else {
          buttonDColor = Colors.green;
        }
      } else {
        // Set color to red if answer is incorrect
        if (buttonIndex == 0) {
          buttonAColor = Colors.red;
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
        // Show quiz completion dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Quiz Completed'),
              content: const Text('You have answered all the questions!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Close the dialog first
                    Navigator.of(context)
                        .pop(); // Go back to the QuizSelectionScreen1
                  },
                  child: const Text('Back to Quiz Selection'),
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
        title: const Text('QUIZ'),
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
                Flexible(
                  child: Text(
                    currentQuestion['question'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B1FA2),
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                  ),
                ),
                SizedBox(height: 10),
                Flexible(
                  child: Text(
                    currentQuestion['article'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                  ),
                ),
                SizedBox(height: 20),
                // Loop through the options dynamically to reduce repetitive code
                for (int i = 0; i < currentQuestion['options'].length; i++)
                  ElevatedButton(
                    onPressed: () =>
                        checkAnswer(currentQuestion['options'][i]['isCorrect'], i),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: i == 0
                          ? buttonAColor
                          : i == 1
                          ? buttonBColor
                          : i == 2
                          ? buttonCColor
                          : buttonDColor ??
                          Colors.white, // Default to white
                      minimumSize: Size(double.infinity, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      currentQuestion['options'][i]['text'],
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB39DDB),
                    minimumSize: Size(double.infinity, 35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Next Question',
                    style: TextStyle(fontSize: 14, color: Colors.white),
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
