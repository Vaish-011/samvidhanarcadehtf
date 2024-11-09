import 'package:flutter/material.dart';

class StateDetailScreen extends StatelessWidget {
  final String stateName;
  final String schedule;

  StateDetailScreen({required this.stateName, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stateName),
        backgroundColor: Color(0xFFF3F7EC),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Color(0xFF9DDE8B),
        padding: EdgeInsets.all(20),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFE6FF94),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$stateName Schedule',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    schedule,
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
