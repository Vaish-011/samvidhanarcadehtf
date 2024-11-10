import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import '../models/part_details.dart'; // Your part_details.dart model class
import '../services/bookmark_manager.dart'; // Import the BookmarkManager class
import 'part_details_page.dart'; // Import the newly created PartDetailsPage

class SummariesPage extends StatelessWidget {
  final BookmarkManager bookmarkManager = BookmarkManager();

  // Function to load the JSON file with enhanced error handling
  Future<List<PartDetails>> _loadPartDetails() async {
    try {
      // Load JSON data from assets
      final String response = await rootBundle.loadString('assets/constitution.json');

      // Decode the JSON
      final List<dynamic> data = json.decode(response);

      // Return a list of PartDetails objects
      return data.map((item) => PartDetails.fromJson(item)).toList();
    } catch (e) {
      // Log the error in the console
      print("Error loading JSON: $e");

      // Rethrow the error to display it in the UI
      throw Exception("Error loading data: $e");
    }
  }

  // Function to check if a part is bookmarked
  Future<bool> isBookmarked(int id) async {
    final bookmarkedParts = await bookmarkManager.getBookmarkedParts();
    return bookmarkedParts.contains(id);
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
            // Display the error message if something goes wrong
            return Center(
              child: Text('Error loading data: ${snapshot.error}'),
            );
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
            child: SingleChildScrollView(  // Make the content scrollable
              child: Padding(
                padding: const EdgeInsets.all(16.0),  // Adjust padding to avoid overflow
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(), // Prevent the grid from scrolling independently
                  shrinkWrap: true,  // Shrink the grid to fit its content
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: partDetails.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<bool>(
                      future: isBookmarked(partDetails[index].id), // Use id here
                      builder: (context, isBookmarkedSnapshot) {
                        bool isBookmarkedPart = isBookmarkedSnapshot.data ?? false;
                        return _buildCard(context, partDetails[index], isBookmarkedPart);
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _toRoman(int number) {
    const romanNumerals = [
      'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X',
      'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI', 'XVII', 'XVIII', 'XIX', 'XX'
    ];
    if (number >= 1 && number <= 20) {
      return romanNumerals[number - 1];
    }
    return number.toString();
  }

  Widget _buildCard(BuildContext context, PartDetails partDetails, bool isBookmarked) {
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
        child: Stack(
          children: [
            Center(
              child: Text(
                'Part ${_toRoman(partDetails.id)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? Colors.black : Colors.grey,
                ),
                onPressed: () async {
                  await bookmarkManager.toggleBookmark(partDetails.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
