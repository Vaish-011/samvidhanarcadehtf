import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle to load the JSON file
import 'test_question_navigate.dart';
class TestSelectionScreen extends StatefulWidget {
  const TestSelectionScreen({Key? key}) : super(key: key);

  @override
  _TestSelectionScreenState createState() => _TestSelectionScreenState();
}

class _TestSelectionScreenState extends State<TestSelectionScreen> {
  List<dynamic> tests = []; // List of tests from the JSON file

  @override
  void initState() {
    super.initState();
    _loadTests(); // Load the list of tests when the screen is initialized
  }

  // Function to load the list of tests from the all_test.json file
  Future<void> _loadTests() async {
    try {
      final String response = await rootBundle.loadString('assets/all_test.json');
      final data = await json.decode(response);
      setState(() {
        tests = data['tests']; // Extract tests list from the JSON
      });
    } catch (e) {
      print('Error loading tests: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Test'),
        backgroundColor: const Color(0xFFB39DDB),
      ),
      body: tests.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
        itemCount: tests.length,
        itemBuilder: (context, index) {
          final test = tests[index];
          return ListTile(
            title: Text(test['testName'] ?? 'Test Name'), // Provide a default value if 'testName' is missing
            onTap: () {
              // Ensure 'testName' exists before navigating
              if (test['testName'] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatchingGame(testName: test['testName']),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

