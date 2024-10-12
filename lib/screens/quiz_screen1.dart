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

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // You can customize the AppBar background color if needed
        elevation: 0, // Optional: Remove shadow for a flat AppBar
        automaticallyImplyLeading: false, // This will remove the back button in the AppBar
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
                onTap: _isAnswered
                    ? null
                    : () {
                  setState(() {
                    _selectedAnswerIndex = index;
                    _isAnswered = true;
                    _isCorrect = currentQuestion.correctAnswer == index;
                  });
                },
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
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
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
                    backgroundColor: Colors.teal, // Customize the button color
                    foregroundColor: Colors.white, // Set the text color to white
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
