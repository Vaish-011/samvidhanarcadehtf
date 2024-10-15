// tamilnadu_screen.dart
import 'package:flutter/material.dart';

class TamilNaduScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tamil Nadu'),
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
            child: SingleChildScrollView( // Wrap the text widget with SingleChildScrollView
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tamil Nadu Details',
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
comprised in the Province of Madras or were being
administered as if they formed part of that Province and
the territories specified in section 4 of the States
Reorganisation Act, 1956,

[and the Second Schedule to
the Andhra Pradesh and Madras (Alteration of
Boundaries) Act, 1959], but excluding the territories
specified in sub-section (1) of section 3 and
sub-section (1) of section 4 of the Andhra State Act, 1953
and [the territories specified in clause (b) of sub-section
(1) of section 5, section 6 and clause (d) of sub-section
(1) of section 7 of the States Reorganisation Act, 1956
and the territories specified in the First Schedule to the Andhra Pradesh and Madras (Alteration of Boundaries) Act, 1959.]''',
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
