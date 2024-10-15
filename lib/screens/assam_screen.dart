// assam_screen.dart
import 'package:flutter/material.dart';

class AssamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assam'),
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
                    'Assam Details',
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
                     commencement of this Constitution were comprised in the
                      Province of Assam, the Khasi States and the Assam Tribal
                     Areas, but excluding the territories
                    specified in the Schedule to the Assam
                      (Alteration of Boundaries) Act, 1951[and the territories
                      specified in sub-section (1) of section 3 of the State of
                       Nagaland Act, 1962] [and the territories specified in
                        sections 5, 6 and 7 of the North-Eastern Areas
                       (Reorganisation) Act, 1971]
                        [and the territories referred
                       to in Part I of the Second Schedule to the Constitution
                         (One Hundredth Amendment) Act, 2015,
                         notwithstanding anything contained
                        in clause (a) of section 3 of the Constitution
                       (Ninth Amendment) Act, 1960, so far as it relates to the
                       territories referred to in Part I of the Second Schedule to
                       the Constitution (One Hundredth Amendment) Act,
                        2015.''',
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
