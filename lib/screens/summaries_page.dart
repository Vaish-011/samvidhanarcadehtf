import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for rootBundle
import '../models/part_details.dart'; // Your part_details.dart model class

class SummariesPage extends StatelessWidget {
  // Function to load the JSON file
  Future<List<PartDetails>> _loadPartDetails() async {
    // Load the JSON file
    final String response = await rootBundle.loadString('assets/constitution.json');
    final List<dynamic> data = json.decode(response);

    // Map the JSON data to PartDetails objects
    return data.map((item) => PartDetails.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<PartDetails>>(
        future: _loadPartDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final partDetails = snapshot.data!;

          return Container(
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
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              padding: EdgeInsets.all(40),
              itemCount: partDetails.length,
              itemBuilder: (context, index) {
                return _buildCard(context, partDetails[index], index + 1); // Pass index + 1 for "Part 1", "Part 2", etc.
              },
            ),
          );
        },
      ),
    );
  }

  // Convert an integer to Roman numeral
  String _toRoman(int number) {
    const romanNumerals = [
      'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X',
      'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI', 'XVII', 'XVIII', 'XIX', 'XX'
    ];
    if (number >= 1 && number <= 20) {
      return romanNumerals[number - 1];
    }
    return number.toString(); // For values larger than 20, just return the number as is.
  }

  Widget _buildCard(BuildContext context, PartDetails partDetails, int partNumber) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PartDetailsPage(partDetails: partDetails),
          ),
        );
      },
      child: Container(
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
            'Part ${_toRoman(partNumber)}', // Display the part number in Roman numerals
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Set the text color to black
            ),
          ),
        ),
      ),
    );
  }
}

class PartDetailsPage extends StatelessWidget {
  final PartDetails partDetails;

  PartDetailsPage({required this.partDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(partDetails.title)),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
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
            padding: EdgeInsets.all(20.0),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    partDetails.content,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
