import 'package:flutter/material.dart';
import 'gemini_page.dart'; // Import the GeminiPage

class SamvidhanBotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate to GeminiPage directly when this page is loaded
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GeminiPage()),
      );
    });

    // Return an empty container as no UI is required
    return Container();
  }
}
