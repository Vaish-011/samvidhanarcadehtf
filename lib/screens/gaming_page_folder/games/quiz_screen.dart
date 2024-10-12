import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  final VoidCallback onCorrectAnswer;
  final VoidCallback onIncorrectAnswer;

  QuizScreen({required this.onCorrectAnswer, required this.onIncorrectAnswer});

  @override
  Widget build(BuildContext context) {
    // Example question and options
    String question = "What is the capital of France?";
    List<String> options = ["Paris", "Berlin", "Madrid", "Rome"];
    String correctAnswer = "Paris";

    return AlertDialog(
      title: Text('Quiz Time!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(question),
          ...options.map((option) {
            return ElevatedButton(
              onPressed: () {
                if (option == correctAnswer) {
                  onCorrectAnswer();
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  onIncorrectAnswer();
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text(option),
            );
          }).toList(),
        ],
      ),
    );
  }
}