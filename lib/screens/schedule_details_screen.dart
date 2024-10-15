import 'package:flutter/material.dart';
import '../models/schedule.dart';
import 'states_screen.dart';

class ScheduleDetailsScreen extends StatelessWidget {
  final Schedule schedule;

  ScheduleDetailsScreen({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(schedule.title),
        backgroundColor: Color(0xFFF5F5F5),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: schedule.details.map((detail) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GestureDetector(
                onTap: () {
                  if (detail == 'States') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StatesScreen()),
                    );
                  }
                  // Add conditions for other details if needed
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF48CFCB),
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
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Text(
                    detail,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
