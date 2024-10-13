import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final VoidCallback onCorrectAnswer;
  final VoidCallback onIncorrectAnswer;

  QuizScreen({required this.onCorrectAnswer, required this.onIncorrectAnswer});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // List of questions and their respective options and correct answers
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the supreme law of the land?',
      'options': ['Constitution', 'Declaration of Independence', 'Bill of Rights', 'Articles of Confederation'],
      'answer': 'Constitution',
    },
    {
      'question': 'What does the Constitution do?',
      'options': ['Sets up the government', 'Defines the government', 'Protects basic rights of Americans', 'All of the above'],
      'answer': 'All of the above',
    },
    {
      'question': 'How many amendments does the Constitution have?',
      'options': ['27', '10', '20', '15'],
      'answer': '27',
    },
    {
      'question': 'Who is in charge of the executive branch?',
      'options': ['President', 'Congress', 'Supreme Court', 'Governor'],
      'answer': 'President',
    },
    // Add more questions as needed
  ];

  int currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get the current question
    final currentQuestion = questions[currentQuestionIndex];

    return AlertDialog(
      title: Text('Quiz Time!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(currentQuestion['question']),
          ...currentQuestion['options'].map<Widget>((option) {
            return ElevatedButton(
              onPressed: () {
                if (option == currentQuestion['answer']) {
                  widget.onCorrectAnswer();
                  Navigator.of(context).pop();
                   // Move to the next question on correct answer
                } else {
                  widget.onIncorrectAnswer();
                  Navigator.of(context).pop(); // Close the dialog on incorrect answer
                }
              },
              child: Text(option),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _nextQuestion() {
    setState(() {
      currentQuestionIndex++;
      // Reset to first question if the end of the list is reached
      if (currentQuestionIndex >= questions.length) {
        currentQuestionIndex = 0;
      }
    });
  }
}
