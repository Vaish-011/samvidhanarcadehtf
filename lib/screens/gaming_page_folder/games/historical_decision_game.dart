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
      appBar: AppBar(
        title: Text("Historical Decision-Making Game"),
        backgroundColor: Color(0xFFB39DDB), // Light purple color for AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.9), // Soft white
              Color(0xFFE1BEE7).withOpacity(0.8), // Lighter purple
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Scenario title
              Text(
                scenario.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF7B1FA2)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Scenario description
              Text(
                scenario.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Choices buttons
              Expanded(
                child: ListView.builder(
                  itemCount: scenario.choices.length,
                  itemBuilder: (context, index) {
                    Choice choice = scenario.choices[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton(
                        onPressed: () => _makeChoice(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB39DDB), // Light purple for buttons
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          choice.text,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Result and feedback messages
              Text(
                _resultMessage,
                style: TextStyle(fontSize: 18, color: Colors.green),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                _feedbackMessage,
                style: TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
