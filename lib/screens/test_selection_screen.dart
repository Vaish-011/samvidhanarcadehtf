import 'package:flutter/material.dart';
import 'test_question_navigate.dart';

class TestSelectionScreen extends StatelessWidget {
  // Create a list of test file names for selection
  final List<String> testFileNames = List.generate(25, (index) => 'test${index + 1}.json');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Test'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: testFileNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Test ${index + 1}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchingGame(testFileName: testFileNames[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
