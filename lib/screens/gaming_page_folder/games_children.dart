import 'package:flutter/material.dart';
import 'games/matching_game.dart';
import 'games/word_find_game.dart';
import 'games/puzzle_game.dart';
import 'games/crossword_game.dart';
import 'games/drag_and_drop_game.dart';

// Import other game pages here if they exist

class GamesChildren extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games For Children'),
        backgroundColor: Color(0xFFE0F2F1), // Light Teal color for AppBar
        elevation: 0, // Remove shadow for a cleaner look
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB2DFDB), // Very Light Teal
              Color(0xFF80CBC4), // Light Teal
              Color(0xFF4DB6AC), // Mid Bright Teal
              Color(0xFF26A69A), // Bright Teal
            ],
            stops: [0.0, 0.33, 0.67, 1.0],
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(context, 'Matching Game', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MatchingGame()), // Navigate to Matching Game
              );
            }),
            _buildCard(context, 'Crossword Game', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CrosswordGame()), // Navigate to Matching Game
              );
              // Navigate to Crossword Game page
              // Navigator.push(context, MaterialPageRoute(builder: (context) => CrosswordGame()));
            }),
            _buildCard(context, 'Puzzle Game', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PuzzleGame()), // Navigate to Matching Game
              );
            }),
            _buildCard(context, 'Drag and Drop Game', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DragAndDropGame()), // Navigate to Matching Game
              );
              // Navigate to Drag and Drop Game page
              // Navigator.push(context, MaterialPageRoute(builder: (context) => DragAndDropGame()));
            }),
            _buildCard(context, 'Word Find Game', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WordFindGame()), // Navigate to Word Find Game
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap(); // Call the function provided for navigation
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        color: Color(0xFFE0F2F1), // Light Teal color for the card background
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Dark color for text
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
