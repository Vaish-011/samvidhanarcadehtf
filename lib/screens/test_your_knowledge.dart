import 'package:flutter/material.dart';
import 'quiz_selection_screen.dart';

class TestYourKnowledgePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Your Knowledge'),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Adjust padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the column
            children: [
              SizedBox(
                height: 200, // Set a fixed height for the Quiz card
                child: _buildCard(context, 'Quiz', QuizSelectionScreen1()),
              ),
              SizedBox(height: 20), // Space between the cards
              SizedBox(
                height: 200, // Set a fixed height for the Test card
                child: _buildCard(context, 'Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, [Widget? screen]) {
    return GestureDetector(
      onTap: () {
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
      child: Card(
        elevation: 4, // Add elevation for visual interest
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        color: Color(0xFFE0F2F1), // Light Teal color for the card background
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24, // Increased font size for better visibility
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
