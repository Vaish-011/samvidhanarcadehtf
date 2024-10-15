// bihar_screen.dart
import 'package:flutter/material.dart';

class BiharScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bihar'),
        backgroundColor: Color(0xFFF3F7EC),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Color(0xFF9DDE8B), // Background color
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView( // Added SingleChildScrollView
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
                    'Bihar Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '''The territories which immediately before the
commencement of this Constitution were either
comprised in the Province of Bihar or were being
administered as if they formed part of that Province
and the territories specified in clause (a) of
sub-section (1) of section 3 of the Bihar and Uttar
Pradesh (Alteration of Boundaries) Act, 1968, but
excluding the territories specified in sub-section (1) of
section 3 of the Bihar and West Bengal (Transfer of Territories) Act, 1956, and the territories
specified in clause (b) of sub-section (1) of section
3 of the first mentioned Act

[and the territories
specified in section 3 of the Bihar Reorganisation Act,
2000].''',
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
      ),
    );
  }
}
