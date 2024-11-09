import 'package:flutter/material.dart';

class WordFindGame extends StatefulWidget {
  const WordFindGame({Key? key}) : super(key: key);

  @override
  _WordFindGameState createState() => _WordFindGameState();
}

class _WordFindGameState extends State<WordFindGame> {
  // List of word sets for different levels
  final List<List<String>> levels = [
    // Level 1
    ['CONSTITUTION', 'RIGHTS', 'FREEDOM', 'EQUALITY'],
    // Level 2
    ['JUSTICE', 'DEMOCRACY', 'LIBERTY', 'FRATERNITY'],
    // Level 3
    ['SOVEREIGNTY', 'SECULARISM', 'GOVERNANCE', 'ELECTION'],
    // Level 4
    ['PARLIAMENT', 'BILL', 'AMENDMENT', 'JURISDICTION'],
    // Level 5
    ['FUNDAMENTAL', 'DUTIES', 'REPRESENTATION', 'CITIZENSHIP'],
  ];

  int currentLevel = 0; // Tracks the current level

  // Access words for the current level
  List<String> get wordsToFind => levels[currentLevel];

  // Different grids for each level
  final List<List<List<String>>> grids = [
    // Grid for Level 1
    [
      ['C', 'O', 'N', 'S', 'T', 'I', 'T'],
      ['U', 'T', 'I', 'O', 'N', 'R', 'I'],
      ['G', 'H', 'T', 'S', 'F', 'R', 'E'],
      ['E', 'E', 'D', 'O', 'M', 'E', 'Q'],
      ['A', 'L', 'I', 'T', 'Y', 'C', 'A'],
      ['B', 'L', 'A', 'S', 'T', 'U', 'S'],
      ['X', 'Q', 'P', 'T', 'R', 'Y', 'T'],
    ],
    // Grid for Level 2
    [
      ['J', 'U', 'S', 'T', 'I', 'C', 'E'],
      ['L', 'I', 'B', 'E', 'R', 'T', 'Y'],
      ['D', 'E', 'M', 'O', 'C', 'R', 'A'],
      ['C', 'R', 'A', 'C', 'Y', 'F', 'R'],
      ['F', 'R', 'A', 'T', 'E', 'R', 'N'],
      ['I', 'T', 'Y', 'X', 'Z', 'O', 'P'],
      ['Q', 'R', 'T', 'S', 'D', 'F', 'G'],
    ],
    // Grid for Level 3
    [
      ['S', 'O', 'V', 'E', 'R', 'E', 'I'],
      ['G', 'H', 'T', 'S', 'E', 'C', 'U'],
      ['L', 'A', 'R', 'I', 'S', 'M', 'R'],
      ['E', 'L', 'E', 'C', 'T', 'I', 'O'],
      ['N', 'G', 'O', 'V', 'E', 'R', 'N'],
      ['A', 'N', 'C', 'E', 'Z', 'O', 'X'],
      ['P', 'D', 'S', 'T', 'F', 'R', 'Q'],
    ],
    // Grid for Level 4
    [
      ['P', 'A', 'R', 'L', 'I', 'A', 'M'],
      ['E', 'N', 'T', 'B', 'I', 'L', 'L'],
      ['A', 'M', 'E', 'N', 'D', 'M', 'E'],
      ['N', 'T', 'J', 'U', 'R', 'I', 'S'],
      ['D', 'I', 'C', 'T', 'I', 'O', 'N'],
      ['A', 'C', 'T', 'U', 'I', 'L', 'O'],
      ['Q', 'R', 'P', 'T', 'X', 'Y', 'Z'],
    ],
    // Grid for Level 5
    [
      ['F', 'U', 'N', 'D', 'A', 'M', 'E'],
      ['N', 'T', 'A', 'L', 'D', 'U', 'T'],
      ['I', 'E', 'S', 'C', 'I', 'T', 'Z'],
      ['I', 'Z', 'E', 'N', 'S', 'H', 'I'],
      ['P', 'R', 'E', 'S', 'E', 'N', 'T'],
      ['A', 'T', 'I', 'O', 'N', 'S', 'C'],
      ['D', 'M', 'Q', 'L', 'T', 'W', 'V'],
    ],
  ];

  List<String> foundWords = []; // Store found words
  List<Offset> selectedCells = []; // Track selected cells
  String selectedWord = ''; // Track current selected word

  @override
  void initState() {
    super.initState();
    _shuffleGrid(); // Shuffle the grid when the game starts
  }

  // Access the grid for the current level
  List<List<String>> get letterGrid => grids[currentLevel];

  // Shuffle the grid letters
  void _shuffleGrid() {
    letterGrid.forEach((row) {
      row.shuffle(); // Shuffle each row
    });
    letterGrid.shuffle(); // Shuffle the entire grid
  }

  void onCellTap(int row, int col) {
    setState(() {
      selectedCells.add(Offset(row.toDouble(), col.toDouble()));
      selectedWord += letterGrid[row][col];

      // Check if selected word is valid and hasn't been found yet
      if (wordsToFind.contains(selectedWord) && !foundWords.contains(selectedWord)) {
        foundWords.add(selectedWord);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Found: $selectedWord!')),
        );
        resetSelection();

        // Check if all words have been found
        if (foundWords.length == wordsToFind.length) {
          // Show a message when all words are found
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All words found! Proceed to the next level.')),
          );
        }
      } else if (!wordsToFind.any((word) => word.startsWith(selectedWord))) {
        resetSelection(); // Reset if no word can be formed from the selection
      }
    });
  }

  void resetSelection() {
    setState(() {
      selectedCells.clear();
      selectedWord = '';
    });
  }

  void nextLevel() {
    if (currentLevel < levels.length - 1) {
      setState(() {
        currentLevel++;
        foundWords.clear();
        selectedCells.clear();
        selectedWord = '';
        _shuffleGrid(); // Shuffle letters for the new level
      });
    } else {
      // If there are no more levels, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have completed all levels!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Find Game - Level ${currentLevel + 1}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Find the words: ${wordsToFind.join(', ')}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // Grid size is 7x7
              ),
              itemCount: letterGrid.length * letterGrid[0].length,
              itemBuilder: (context, index) {
                int row = index ~/ 7;
                int col = index % 7;

                bool isSelected = selectedCells.contains(Offset(row.toDouble(), col.toDouble()));

                return GestureDetector(
                  onTap: () => onCellTap(row, col),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4), // Smaller rounded boxes
                    ),
                    child: Center(
                      child: Text(
                        letterGrid[row][col],
                        style: TextStyle(
                          fontSize: 22, // Reduced font size to fit smaller boxes
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (foundWords.length == wordsToFind.length)
            ElevatedButton(
              onPressed: nextLevel,
              child: const Text('Next Level'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          const SizedBox(height: 20), // Space at the bottom for better layout
        ],
      ),
    );
  }
}