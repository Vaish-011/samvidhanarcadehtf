import 'package:flutter/material.dart';

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
                _buildMenuItem(context, Icons.bookmark, 'Bookmark'),
                _buildMenuItem(context, Icons.logout, 'Logout'),
                _buildMenuItem(context, Icons.feedback, 'Feedback'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build menu items
  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
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
            // Handle navigation or actions here
          },
        ),
      ),
    );
  }
}