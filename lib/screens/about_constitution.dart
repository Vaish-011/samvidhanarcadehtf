import 'package:flutter/material.dart';
import 'preamble_page.dart'; // Import the PreamblePage
import 'amendment_sreen.dart';
import 'article_selection_screen.dart';
import 'schedules_screen.dart';

class AboutConstitutionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Constitution'),
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
            _buildCard(context, 'Preamble', PreamblePage()), // Pass the PreamblePage to the card
            _buildCard(context, 'Articles',ArticleSelectionScreen()),
            _buildCard(context, 'Schedules',SchedulesScreen()),
            _buildCard(context, 'Amendments',AmendmentsScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, [Widget? nextScreen]) {
    return GestureDetector(
      onTap: () {
        if (nextScreen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextScreen),
          );
        }
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
