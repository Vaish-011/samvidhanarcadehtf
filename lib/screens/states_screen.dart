// states_screen.dart
import 'package:flutter/material.dart';
import 'andhra_pradesh_screen.dart'; // Import the Andhra Pradesh screen
import 'assam_screen.dart'; // Import the Assam screen
import 'Bihar.dart'; // Import the Bihar screen
import 'gujarat_screen.dart'; // Import the Gujarat screen
import 'kerala_screen.dart'; // Import the Kerala screen
import 'madhya_pradesh_screen.dart'; // Import the Madhya Pradesh screen
import 'tamilnadu_screen.dart'; // Import the Tamil Nadu screen
import 'maharashtra_screen.dart'; // Import the Maharashtra screen

class StatesScreen extends StatelessWidget {
  final List<String> states = [
    'Andhra Pradesh',
    'Assam',
    'Bihar',
    'Gujarat',
    'Kerala',
    'Madhya Pradesh', // Added Madhya Pradesh to the list
    'Tamil Nadu',    // Added Tamil Nadu to the list
    'Maharashtra',   // Added Maharashtra to the list
    'Karnataka',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Uttar Pradesh',
    'West Bengal',
    'Nagaland',
    'Haryana',
    'Himachal Pradesh',
    'Manipur',
    'Tripura',
    'Meghalaya',
    'Sikkim',
    'Mizoram',
    'Arunachal Pradesh',
    'Goa',
    'Chhattisgarh',
    'Uttarakhand',
    'Jharkhand',
    'Telangana',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('States of India'),
        backgroundColor: Color(0xFFF5F5F5),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: states.length,
        itemBuilder: (context, index) {
          final state = states[index];

          return GestureDetector(
            onTap: () {
              if (state == 'Andhra Pradesh') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AndhraPradeshScreen()),
                );
              } else if (state == 'Assam') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssamScreen()),
                );
              } else if (state == 'Bihar') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BiharScreen()),
                );
              } else if (state == 'Gujarat') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GujaratScreen()),
                );
              } else if (state == 'Kerala') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KeralaScreen()),
                );
              } else if (state == 'Madhya Pradesh') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MadhyaPradeshScreen()),
                );
              } else if (state == 'Tamil Nadu') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TamilNaduScreen()),
                );
              } else if (state == 'Maharashtra') { // Added Maharashtra case
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MaharashtraScreen()),
                );
              } else {
                // Add more state-specific screens here
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF6CC4A1), // Updated color
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
                  state,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
