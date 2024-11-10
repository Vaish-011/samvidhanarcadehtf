import 'package:flutter/material.dart';
import '../screens/feedback_form_screen.dart';
import '../screens/bookmarked_summaries_screen.dart'; // Import BookmarkedSummariesScreen
import '../screens/login_page.dart';

class SidebarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          // Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB2DFDB), // Very Light Teal
                  Color(0xFF80CBC4), // Light Teal
                ],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10), // Adds spacing at the top
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.black, // Dark color for header text
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildMenuItem(context, Icons.person, 'Profile'),
                _buildMenuItem(context, Icons.bookmark, 'Bookmark', isBookmark: true), // Modify for Bookmark
                _buildMenuItem(context, Icons.logout, 'Logout',isLogout: true),
                _buildMenuItem(context, Icons.feedback, 'Feedback', isFeedback: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build menu items
  Widget _buildMenuItem(BuildContext context, IconData icon, String title, {bool isFeedback = false, bool isBookmark = false,bool isLogout = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      child: Card(
        elevation: 4, // Add elevation for visual interest
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Smooth rounded corners
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.black), // Dark color for icons
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black, // Dark color for text
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          onTap: () {
            // Navigate to FeedbackFormScreen if this is the Feedback menu item
            if (isFeedback) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackFormScreen(),
                ),
              );
            }
            // Navigate to BookmarkedSummariesScreen if this is the Bookmark menu item
            else if (isBookmark) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarkedSummariesScreen(), // Navigate to BookmarkedSummariesScreen
                ),
              );
            }else if (isLogout) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(), // Navigate to BookmarkedSummariesScreen
                ),
              );
            } else {
              // Handle other menu items' actions here
            }
          },
        ),
      ),
    );
  }
}
