import 'package:flutter/material.dart';
import '../models/part_details.dart'; // Ensure this is imported

class PartDetailsPage extends StatelessWidget {
  final PartDetails partDetails;

  PartDetailsPage({required this.partDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700], // Customized AppBar color
        title: Text(partDetails.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView( // Wrapping the content in a SingleChildScrollView for scrollability
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // Add top and bottom padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.teal[100], // Soft background color for title
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8.0)],
              ),
              child: Text(
                partDetails.title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800], // Darker color for better contrast
                ),
                textAlign: TextAlign.center, // Center the title
              ),
            ),
            SizedBox(height: 20), // Space between title and content

            // Content Section
            Text(
              partDetails.content,  // Content from 'partDetails'
              style: TextStyle(
                fontSize: 18, // Increase font size for better readability
                height: 1.6, // Line height to make it more readable
                color: Colors.black87, // Slightly muted text color
              ),
            ),
            SizedBox(height: 40), // Extra spacing at the bottom
          ],
        ),
      ),
    );
  }
}
