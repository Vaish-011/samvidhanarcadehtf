import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart'; // Import your Firestore service

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({Key? key}) : super(key: key);

  @override
  _PuzzleGameState createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> levels = [];
  String currentWord = '';
  List<String> shuffledLetters = [];
  bool gameComplete = false;
  int wordIndex = 0;
  bool showInstructions = true;

  @override
  void initState() {
    super.initState();
    loadLevels();
  }

  Future<void> loadLevels() async {
    final String response = await rootBundle.loadString('assets/puzzle_game.json');
    final List<dynamic> data = json.decode(response);
    levels = data.map((item) => item as Map<String, dynamic>).toList();
    _loadNextWord();
  }

  void _loadNextWord() {
    setState(() {
      if (wordIndex >= levels.length) {
        wordIndex = 0; // Reset to first word after last word is completed
      }
      currentWord = levels[wordIndex]['word']; // Get the current word from JSON
      shuffledLetters = currentWord.split(''); // Split word into letters
      shuffledLetters.shuffle(Random()); // Shuffle the letters
      gameComplete = false;
      wordIndex++; // Move to the next word for next time
    });
  }

  bool _checkIfComplete() {
    return shuffledLetters.join('') == currentWord; // Check if the letters form the current word
  }

  void _goToNextPuzzle() {
    if (gameComplete) {
      _loadNextWord(); // Load the next word puzzle
      saveCompletedLevel(); // Save the completed level in Firestore
    }
  }

  Future<void> saveCompletedLevel() async {
    String userId = _auth.currentUser?.uid ?? "YOUR_USER_ID"; // Use the current user's ID
    await _firestoreService.updatePuzzleGameLevels(userId, wordIndex); // Save to the puzzle game collection
  }

  @override
  Widget build(BuildContext context) {
    if (showInstructions) {
      return _buildInstructionsPage();
    }

    // Ensure we have a current word loaded
    if (currentWord.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Constitution Puzzle Game'),
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
          if (gameComplete)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Congratulations! Puzzle completed!',
                    style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _goToNextPuzzle,
                    child: const Text('Next Puzzle'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: sqrt(currentWord.length).toInt() > 0 ? sqrt(currentWord.length).toInt() : 1, // Ensure at least 1
              ),
              itemCount: currentWord.length,
              itemBuilder: (context, index) {
                return DragTarget<int>(
                  onWillAccept: (fromIndex) => fromIndex != index,
                  onAccept: (fromIndex) {
                    setState(() {
                      // Swap the letters
                      final temp = shuffledLetters[fromIndex];
                      shuffledLetters[fromIndex] = shuffledLetters[index];
                      shuffledLetters[index] = temp;
                      gameComplete = _checkIfComplete();
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Draggable<int>(
                      data: index,
                      feedback: _buildPuzzlePiece(index),
                      childWhenDragging: Container(color: Colors.grey[300]),
                      child: _buildPuzzlePiece(index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzlePiece(int index) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      color: Colors.blueAccent,
      child: Center(
        child: Text(
          shuffledLetters[index], // Display individual shuffled letters
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildInstructionsPage() {
    return Scaffold(
      appBar: AppBar(title: const Text('Instructions')),
      body: PageView(
        children: [
          _buildInstructionSlide(
            title: 'Welcome to the Puzzle Game',
            description: 'This game will help you learn about the Constitution while having fun!',
            showArrow: true,
          ),
          _buildInstructionSlide(
            title: 'How to Play',
            description: 'Drag and drop letters to form the correct word.',
            showArrow: true,
          ),
          _buildInstructionSlide(
            title: 'Levels',
            description: 'Select different levels from the menu to play.',
            showArrow: true,
          ),
          _buildInstructionSlide(
            title: 'Have Fun!',
            description: 'Let’s get started! Click below to play the game.',
            onNext: () {
              setState(() {
                showInstructions = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionSlide({required String title, required String description, VoidCallback? onNext, bool showArrow = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[100]!, Colors.blue[300]!],
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
          if (showArrow) Icon(Icons.arrow_forward, size: 48, color: Colors.blue),
          if (onNext != null)
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Start Playing'),
            ),
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
                      setState(() {
                        wordIndex = index;
                        _loadNextWord();
                      });
                      Navigator.of(context).pop();
                    },
                  );
                }),
                ListTile(
                  leading: Icon(Icons.replay, color: Colors.redAccent),
                  title: const Text('Restart from Level 1'),
                  onTap: () {
                    setState(() {
                      wordIndex = 0;
                      _loadNextWord();
                    });
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
