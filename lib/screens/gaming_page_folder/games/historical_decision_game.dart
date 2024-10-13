import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // For loading the JSON file

class HistoricalDecisionGame extends StatefulWidget {
  @override
  _HistoricalDecisionGameState createState() => _HistoricalDecisionGameState();
}

class _HistoricalDecisionGameState extends State<HistoricalDecisionGame> {
  List<Scenario> _scenarios = [];
  int _currentScenarioIndex = 0;
  String _resultMessage = '';
  String _feedbackMessage = '';

  @override
  void initState() {
    super.initState();
    _loadScenarios();
  }

  Future<void> _loadScenarios() async {
    String data = await rootBundle.loadString('assets/historical_decision_game.json');
    final jsonResult = jsonDecode(data);

    setState(() {
      _scenarios = (jsonResult['scenarios'] as List)
          .map((scenario) => Scenario.fromJson(scenario))
          .toList();
    });
  }

  void _makeChoice(int choiceIndex) {
    setState(() {
      Choice selectedChoice = _scenarios[_currentScenarioIndex].choices[choiceIndex];
      _resultMessage = selectedChoice.outcome;
      _feedbackMessage = selectedChoice.isCorrect
          ? "You made the right decision!"
          : "This decision was not ideal historically.";
      _currentScenarioIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_scenarios.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Loading...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentScenarioIndex >= _scenarios.length) {
      return Scaffold(
        appBar: AppBar(title: Text("Game Over")),
        body: Center(
          child: Text(
            "Game Over! $_resultMessage\n$_feedbackMessage",
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final scenario = _scenarios[_currentScenarioIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Historical Decision-Making Game")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              scenario.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              scenario.description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ...scenario.choices.asMap().entries.map((entry) {
              int index = entry.key;
              Choice choice = entry.value;
              return ElevatedButton(
                onPressed: () => _makeChoice(index),
                child: Text(choice.text),
              );
            }).toList(),
            SizedBox(height: 20),
            Text(
              _resultMessage,
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            Text(
              _feedbackMessage,
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class Scenario {
  final String title;
  final String description;
  final List<Choice> choices;

  Scenario({
    required this.title,
    required this.description,
    required this.choices,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    return Scenario(
      title: json['title'],
      description: json['description'],
      choices: (json['choices'] as List)
          .map((choice) => Choice.fromJson(choice))
          .toList(),
    );
  }
}

class Choice {
  final String text;
  final String outcome;
  final bool isCorrect;

  Choice({
    required this.text,
    required this.outcome,
    required this.isCorrect,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      text: json['text'],
      outcome: json['outcome'],
      isCorrect: json['isCorrect'],
    );
  }
}
