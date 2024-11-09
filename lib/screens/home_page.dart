import 'package:flutter/material.dart';
import '../widgets/sidebar_menu.dart';
import 'about_constitution.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Adjust the height as needed
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFE0F2F1), // Light Teal color for the AppBar background
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF004D40), // Dark Teal color for the border
                width: 4.0, // Thickness of the border
              ),
            ),
          ),
          child: AppBar(
            title: Text(
              'Samvidhan Arcade',
              style: TextStyle(
                color: Colors.black, // Darker color for text
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial', // Use a default font style
              ),
            ),
            backgroundColor: Colors.transparent, // Make AppBar background transparent
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.menu, color: Colors.black), // Dark color for icon
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            elevation: 0, // Remove shadow for a cleaner look
          ),
        ),
      ),
      drawer: SidebarMenu(),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            width: double.infinity,
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
                stops: [0.0, 0.33, 0.67, 1.0], // Adjusted gradient stops for a brighter look
              ),
            ),
          ),
          // GridView on top of gradient background
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildCard(context, 'About Constitution', AboutConstitutionPage()),
                _buildCard(context, 'Learning Resources', null), // No navigation
                _buildCard(context, 'Gaming Page', null), // No navigation
                _buildCard(context, 'Test Your Knowledge', null), // No navigation
                _buildCard(context, 'Summaries', null), // No navigation
                _buildCard(context, 'Daily News', null), // No navigation
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Modified _buildCard method: Only navigates if the page is not null
  Widget _buildCard(BuildContext context, String title, Widget? page) {
    return GestureDetector(
      onTap: () {
        // Only navigate if the page is not null (i.e., About Constitution page)
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Smooth rounded corners
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color(0xFF80CBC4), // Light Teal
                Color(0xFFB2DFDB), // Very Light Teal
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                offset: Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Darker color for text
                fontFamily: 'Arial', // Use a default font style
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
