import 'package:flutter/material.dart';
import 'youtube_links_page.dart';  // Import the LearningResourcesPage
import 'podcast_list_screen.dart';  // Import the PodcastListScreen
import 'package:samvidhan_arcade/screens/casestudy_list_screen.dart';

class LearningResourcesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Resources'),
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
              Expanded(child: _buildCard(context, 'YouTube Links')),
              SizedBox(height: 20), // Space between cards
              Expanded(child: _buildCard(context, 'Podcast Links')),
              SizedBox(height: 20), // Space between cards
              Expanded(child: _buildCard(context, 'Case Studies')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        if (title == 'YouTube Links') {
          // Navigate to LearningResourcesPage when YouTube Links card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => YoutubeLinksPage()),
          );
        } else if (title == 'Podcast Links') {
          // Navigate to PodcastListScreen when Podcast Links card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PodcastListScreen()),
          );
        }else if (title == 'Case Studies') {
          // Navigate to PodcastListScreen when Podcast Links card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CasestudyListScreen()),
          );
        }
        else {
          // Add other navigation logic for 'Case Studies' or other cards if needed
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
