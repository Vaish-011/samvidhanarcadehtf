import 'package:flutter/material.dart';

class MultilingualMaterialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Multilingual Materials',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black, // Set text color to black for contrast
          ),
        ),
        backgroundColor: Colors.white, // Set the AppBar background color to white
        elevation: 0, // Remove shadow for a flat look, if desired
        iconTheme: IconThemeData(
          color: Colors.black, // Set icon color to black for better visibility
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal[50]!,
              Colors.teal[100]!,
            ],
          ),
        ),
        child: Center(
          child: Container(
            color: Colors.white, // White background behind the main text
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Content for Multilingual Materials will be displayed here.',
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
