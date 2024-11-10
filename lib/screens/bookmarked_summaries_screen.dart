import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle to load assets
import '../services/bookmark_manager.dart';
import '../models/part_details.dart';
import 'part_details_page.dart'; // Import PartDetailsPage

class BookmarkedSummariesScreen extends StatelessWidget {
  final BookmarkManager bookmarkManager = BookmarkManager();

  // Fetch bookmarked summaries based on bookmarked part ids
  Future<List<PartDetails>> _getBookmarkedSummaries() async {
    final bookmarkedParts = await bookmarkManager.getBookmarkedParts();
    final allParts = await loadAllParts();
    // Filter out parts that are bookmarked
    return allParts.where((part) => bookmarkedParts.contains(part.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Summaries'),
        backgroundColor: Color(0xFF5FBBEF),
      ),
      body: FutureBuilder<List<PartDetails>>(
        future: _getBookmarkedSummaries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading bookmarks'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookmarks available'));
          }

          final bookmarkedSummaries = snapshot.data!;

          return SingleChildScrollView(  // Wrap the entire ListView inside a scrollable widget
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(  // Use Column to display ListTiles inside SingleChildScrollView
                children: List.generate(bookmarkedSummaries.length, (index) {
                  final partDetails = bookmarkedSummaries[index]; // Full PartDetails object
                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.bookmark, color: Color(0xFF3F51B5)),
                      title: Text(
                        partDetails.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3F51B5),
                        ),
                      ),
                      subtitle: Text(
                        partDetails.content.length > 50
                            ? partDetails.content.substring(0, 50) + '...'
                            : partDetails.content,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PartDetailsPage(partDetails: partDetails), // Pass the full PartDetails object
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Define a helper function to load all parts data
Future<List<PartDetails>> loadAllParts() async {
  final String response = await rootBundle.loadString('assets/constitution.json');
  final List<dynamic> data = json.decode(response);
  return data.map((item) => PartDetails.fromJson(item)).toList();
}
