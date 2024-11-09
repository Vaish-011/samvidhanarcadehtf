import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;

  QuizScreen({required this.questions});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  bool _isCorrect = false;
  int _totalPoints = 0; // Track total points

  void _checkAnswer() {
    setState(() {
      _isAnswered = true;
      _isCorrect = widget.questions[_currentQuestionIndex].correctAnswer == _selectedAnswerIndex;

      // Update points
      if (_isCorrect) {
        _totalPoints += 1; // Earn 1 point for correct answer
        _showCorrectAnswerDialog();
      } else {
        _totalPoints -= 1; // Deduct 1 point for incorrect answer
        _showIncorrectAnswerDialog();
      }
    });
  }

  void _showCorrectAnswerDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.green.shade100,
      builder: (context) {
        return _buildFeedbackDialog(
          icon: Icons.check_circle,
          iconColor: Colors.green,
          title: "Nice job!",
          buttonText: "Continue",
          onButtonPressed: () {
            Navigator.of(context).pop();
            _nextQuestion();
          },
        );
      },
    );
  }

  void _showIncorrectAnswerDialog() {
    final correctAnswerText = widget.questions[_currentQuestionIndex]
        .options[widget.questions[_currentQuestionIndex].correctAnswer];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.red.shade100,
      builder: (context) {
        return _buildFeedbackDialog(
          icon: Icons.close,
          iconColor: Colors.red,
          title: "Incorrect",
          subtitle: "Correct Answer: $correctAnswerText",
          buttonText: "Got It",
          onButtonPressed: () {
            Navigator.of(context).pop();
            _nextQuestion();
          },
        );
      },
    );
  }

  Widget _buildFeedbackDialog({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 60),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(color: iconColor, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 10),
            Text(
              subtitle,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: iconColor,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < widget.questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Show quiz completed dialog when finished
        _showCompletionDialog();
      }
      _selectedAnswerIndex = null;
      _isAnswered = false;
      _isCorrect = false;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Quiz Completed!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Great! You've earned $_totalPoints coins!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/coin.png',
                height: 50,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(_totalPoints); // Return the total points to the previous screen
              },
              child: Text("Finish"),
            ),
          ],
        );
      },
    );
  }

  Color _getOptionBackgroundColor(int index) {
    if (_isAnswered && index == _selectedAnswerIndex) {
      return _isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    } else if (!_isAnswered && index == _selectedAnswerIndex) {
      return Colors.blue.shade100;
    }
    return Colors.white;
  }

  Color _getOptionBorderColor(int index) {
    if (_isAnswered && index == _selectedAnswerIndex) {
      return _isCorrect ? Colors.green : Colors.red;
    } else if (!_isAnswered && index == _selectedAnswerIndex) {
      return Colors.blue;
    }
    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300, width: 1.5),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        currentQuestion.question,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 10),
                    ...List.generate(currentQuestion.options.length, (index) {
                      final option = currentQuestion.options[index];
                      return GestureDetector(
                        onTap: _isAnswered
                            ? null
                            : () {
                          setState(() {
                            _selectedAnswerIndex = index;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: _getOptionBackgroundColor(index),
                            border: Border.all(
                              color: _getOptionBorderColor(index),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${String.fromCharCode(65 + index)}. ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: !_isAnswered && _selectedAnswerIndex != null
                    ? _checkAnswer
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text("Check"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
