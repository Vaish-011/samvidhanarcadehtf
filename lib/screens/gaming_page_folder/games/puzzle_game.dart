import 'package:flutter/material.dart';
import 'dart:math';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({Key? key}) : super(key: key);

  @override
  _PuzzleGameState createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  final List<String> words = [
    'Rights', 'Laws', 'Justice',
    'Amendment', 'Liberty', 'Equality',
    'Freedom', 'Democracy', 'Sovereignty'
  ];
  String currentWord = '';
  List<String> shuffledLetters = [];
  bool gameComplete = false;
  int wordIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadNextWord();
  }

  void _loadNextWord() {
    setState(() {
      if (wordIndex >= words.length) {
        wordIndex = 0; // Reset to first word after last word is completed
      }
      currentWord = words[wordIndex]; // Get the current word
      shuffledLetters = currentWord.split(''); // Split word into letters
      shuffledLetters.shuffle(Random()); // Shuffle the letters
      gameComplete = false;
      wordIndex++; // Move to the next word for next time
    });
  }

  bool _checkIfComplete() {
    for (int i = 0; i < shuffledLetters.length; i++) {
      if (shuffledLetters[i] != currentWord[i]) return false;
    }
    return true;
  }

  void _goToNextPuzzle() {
    _loadNextWord(); // Load the next word puzzle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Constitution Puzzle Game'),
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
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _goToNextPuzzle, // Move to the next puzzle
                    child: const Text('Next Puzzle'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: sqrt(currentWord.length).toInt(),
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
                      childWhenDragging: Container(
                        color: Colors.grey[300],
                      ),
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
}
