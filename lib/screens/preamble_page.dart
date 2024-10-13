import 'package:flutter/material.dart';

class PreamblePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preamble'),
        backgroundColor: Color(0xFFE0F2F1), // Light Teal color for AppBar
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Preamble of the Constitution',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            // Correctly reference the image asset
            Image.asset(
              'assets/preamble_screenshot.jpg', // Adjusted path
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
