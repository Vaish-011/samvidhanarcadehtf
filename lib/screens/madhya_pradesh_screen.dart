// madhya_pradesh_screen.dart
import 'package:flutter/material.dart';

class MadhyaPradeshScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Madhya Pradesh'),
        backgroundColor: Color(0xFFF3F7EC),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Color(0xFF9DDE8B), // Background color
        padding: EdgeInsets.all(20),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFE6FF94), // Content box color
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Madhya Pradesh Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  '''The territories specified in sub-section (1) of section 9 of
the States Reorganisation Act, 1956 
[and the First Schedule to the Rajasthan and Madhya Pradesh 
(Transfer of Territories) Act, 1959], 
[but excluding the territories specified in section 3 of the 
Madhya Pradesh Reorganisation Act, 2000].''',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
