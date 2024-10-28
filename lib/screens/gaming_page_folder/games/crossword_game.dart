import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class CrosswordGame extends StatefulWidget {
  const CrosswordGame({Key? key}) : super(key: key);

  @override
  _CrosswordGameState createState() => _CrosswordGameState();
}

class _CrosswordGameState extends State<CrosswordGame> {
  int currentLevel = 0;
  String formedWord = '';
  List<int> selectedIndexes = [];
  List<String> shuffledLetters = [];
  List<Map<String, dynamic>> levels = [];
  bool showInstructions = true;

  @override
  void initState() {
    super.initState();
    loadLevels();
  }

  Future<void> loadLevels() async {
    final String response = await rootBundle.loadString('assets/crossword_game.json');
    final List<dynamic> data = json.decode(response);
    levels = data.map((item) => item as Map<String, dynamic>).toList();
    await loadSavedLevel();
    shuffleLetters();
    setState(() {});
  }

  Future<void> loadSavedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentLevel = prefs.getInt('saved_level') ?? 0;
    });
  }

  Future<void> saveCurrentLevel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('saved_level', currentLevel);
  }

  void shuffleLetters() {
    shuffledLetters = List.from(levels[currentLevel]['letters']);
    shuffledLetters.shuffle(Random());
  }

  void selectLetter(int index) {
    setState(() {
      formedWord += shuffledLetters[index];
      selectedIndexes.add(index);
    });
  }

  void resetGame() {
    setState(() {
      formedWord = '';
      selectedIndexes.clear();
    });
  }

  void checkWord() {
    if (formedWord == levels[currentLevel]['correctWord']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Correct! ${levels[currentLevel]['correctWord']}: ${levels[currentLevel]['explanation']}',
          ),
        ),
      );
      moveToNextLevel();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oops! Try again.')),
      );
      resetGame();
    }
  }

  void moveToNextLevel() {
    setState(() {
      if (currentLevel < levels.length - 1) {
        currentLevel++;
      } else {
        currentLevel = 0;
      }
      shuffleLetters();
      resetGame();
      saveCurrentLevel();
    });
  }

  void selectLevel(int level) {
    setState(() {
      currentLevel = level;
      resetGame();
      shuffleLetters();
      saveCurrentLevel();
    });
  }

  void restartGame() {
    setState(() {
      currentLevel = 0;
      resetGame();
      shuffleLetters();
      saveCurrentLevel();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showInstructions) {
      return _buildInstructionsPage();
    }

    if (levels.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    String currentHint = levels[currentLevel]['hint'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Constitution Crossword - Level ${currentLevel + 1}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _showLevelSelectionDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Hint: $currentHint',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              itemCount: shuffledLetters.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: selectedIndexes.contains(index) ? null : () => selectLetter(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: selectedIndexes.contains(index) ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        shuffledLetters[index],
                        style: const TextStyle(fontSize: 24, color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Formed Word: $formedWord',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: resetGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: checkWord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsPage() {
    return Scaffold(
      appBar: AppBar(title: const Text('Instructions')),
      body: PageView(
        children: [
          _buildInstructionSlide(
            title: 'Welcome to the Crossword Game',
            description: 'This game will help you learn about the Constitution while having fun!',
            showArrow: true, // Arrow shown
          ),
          _buildInstructionSlide(
            title: 'How to Play',
            description: 'Select letters to form words based on the hints provided.',
            showArrow: true, // Arrow shown
          ),
          _buildInstructionSlide(
            title: 'Levels',
            description: 'You can select different levels by tapping on the menu icon in the top right corner.',
            showArrow: true, // Arrow shown
          ),
          _buildInstructionSlide(
            title: 'Have Fun!',
            description: 'Let’s get started! Click below to play the game.',
            onNext: () {
              setState(() {
                showInstructions = false;
              });
            },
            showArrow: false, // No arrow for last slide
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionSlide({
    required String title,
    required String description,
    VoidCallback? onNext,
    bool showArrow = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[100]!, Colors.green[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          if (onNext != null) ...[
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Start Playing'),
            ),
            const SizedBox(height: 20),
          ],
          if (showArrow)
            Icon(Icons.arrow_forward, size: 40, color: Colors.blue), // Arrow added for each applicable slide
        ],
      ),
    );
  }

  void _showLevelSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Level'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ...List.generate(levels.length, (index) {
                  return ListTile(
                    leading: Icon(Icons.star, color: Colors.blueAccent),
                    title: Text('Level ${index + 1}'),
                    onTap: () {
                      selectLevel(index);
                      Navigator.of(context).pop();
                    },
                  );
                }),
                ListTile(
                  leading: Icon(Icons.replay, color: Colors.redAccent),
                  title: const Text('Restart from Level 1'),
                  onTap: () {
                    restartGame();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
