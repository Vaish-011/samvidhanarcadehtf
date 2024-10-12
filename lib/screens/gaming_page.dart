import 'package:flutter/material.dart';
import 'gaming_page_folder/games_children.dart';
// Import the pages for Games for Adults and Constitutional Quest
import 'gaming_page_folder/games_adult.dart'; // Make sure to create this file
import 'gaming_page_folder/constitutional_quest.dart'; // Make sure to create this file

class GamingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gaming Page'),
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
          padding: const EdgeInsets.all(20.0), // Space from the edges
          child: Column(
            children: [
              SizedBox(height: 20), // Space from the top
              Expanded(
                child: _buildCard(
                  context,
                  'Games for Children',
                  GamesChildren(), // Pass the GamesChildren page here
                ),
              ),
              SizedBox(height: 20), // Space between cards
              Expanded(
                child: _buildCard(
                  context,
                  'Games for Adults',
                  GamesAdult(), // Pass the GamesAdult page here
                ),
              ),
              SizedBox(height: 20), // Space between cards
              Expanded(
                child: _buildCard(
                  context,
                  'Constitutional Quest',
                  ConstitutionalQuest(), // Pass the ConstitutionalQuest page here
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
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
