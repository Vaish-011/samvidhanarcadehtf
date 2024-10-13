import 'package:flutter/material.dart';
import 'quiz_question_navigate.dart';

class QuizSelectionScreen1 extends StatelessWidget {
  // Create a list of quiz file names for easy management
  final List<String> quizFileNames = List.generate(25, (index) => 'quiz${index + 1}.json');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Quiz'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: quizFileNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Quiz ${index + 1}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchingGame(quizFileName: quizFileNames[index]), // Pass quiz file name
                ),
              );
            },
          );
        },
      ),
    );
  }
}
