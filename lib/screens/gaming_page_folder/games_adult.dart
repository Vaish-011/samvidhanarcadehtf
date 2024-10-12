import 'package:flutter/material.dart';

class GamesAdult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games For Adults'),
        backgroundColor: Color(0xFFE0F2F1), // Light Teal color for AppBar
        elevation: 0, // Remove shadow for a cleaner look
      ),
      body: Center(
        child: Text('Games for Adults Content Here'), // Placeholder content
      ),
    );
  }
}
