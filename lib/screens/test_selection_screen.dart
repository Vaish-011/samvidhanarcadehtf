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
        title: const Text('Select Quiz'),
        backgroundColor: const Color(0xFFB39DDB), // Classy purple color
      ),
      body: tests.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: tests.length,
        itemBuilder: (context, index) {
          final test = tests[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                test['testName'] ?? 'Test Name',
                style: const TextStyle(
                  color: Color(0xFF673AB7), // Purple text color
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // Ensure 'testName' exists before navigating
                if (test['testName'] != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MatchingGame(testName: test['testName']),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
