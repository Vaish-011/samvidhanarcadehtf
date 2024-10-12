import 'package:flutter/material.dart';

class SummariesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildCard(context, 'PART I'),
            _buildCard(context, 'PART II'),
            _buildCard(context, 'PART III'),
            _buildCard(context, 'PART IV'),
            _buildCard(context, 'PART V'),
            _buildCard(context, 'PART VI'),
            _buildCard(context, 'PART VII'),
            _buildCard(context, 'PART VIII'),
            _buildCard(context, 'PART IX'),
            _buildCard(context, 'PART X'),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        // Handle box tap; you can navigate to another page or show details here
        print('$title tapped');
      },
      child: Container(
        width: 100, // Set the width of the box
        height: 100, // Set the height of the box
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16, // Adjust font size for smaller boxes
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
