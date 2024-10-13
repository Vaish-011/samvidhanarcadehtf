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
  int _score = 0; // Variable to track the score

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _selectedAnswerIndex = null;
      _isAnswered = false;
      _isCorrect = false;
    });
  }

  Color _getOptionBackgroundColor(int index) {
    if (_isAnswered && index == _selectedAnswerIndex) {
      return _isCorrect ? Colors.green : Colors.red;
    }
    return Colors.white;
  }

  Widget _showCorrectAnswer(Question question) {
    if (_isAnswered && !_isCorrect) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          "Correct Answer: ${question.options[question.correctAnswer]}",
          style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
    return SizedBox.shrink();
  }

  void _checkAnswer(int index) {
    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;
      _isCorrect = widget.questions[_currentQuestionIndex].correctAnswer == index;
      if (_isCorrect) {
        _score++; // Increment score if the answer is correct
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestionIndex >= widget.questions.length) {
      // Display score if all questions are answered
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular score display
              Container(
                width: 150, // Reduced circle size
                height: 150, // Reduced circle size
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$_score',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5), // Space between score and total
                      Text(
                        '/${widget.questions.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Show congratulations message if the user has answered all questions correctly
              if (_score == widget.questions.length)
                Text(
                  "Congratulations!!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate back or restart the quiz
                  Navigator.pop(context);
                },
                child: Text(
                  'Back to Levels',
                  style: TextStyle(color: Colors.white), // Set the text color to white
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = widget.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion.question,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...List.generate(currentQuestion.options.length, (index) {
              final option = currentQuestion.options[index];

              return GestureDetector(
                onTap: _isAnswered ? null : () => _checkAnswer(index),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: _getOptionBackgroundColor(index),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${String.fromCharCode(65 + index)}. ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            _showCorrectAnswer(currentQuestion),
            SizedBox(height: 20),
            if (_isAnswered)
              Center(
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Next Question'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
