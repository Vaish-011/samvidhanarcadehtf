import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart'; // Import your HomeScreen

class ThankYouScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thank You'),
        backgroundColor: Colors.purple[400], // Light purple color for the app bar
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[50]!, // Lighter purple
              Colors.purple[100]!, // Lighter purple
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Heartwarming message
                Text(
                  'Thank You for Your Feedback!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                    fontFamily: 'Roboto', // Elegant font
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Image or icon to make the UI warm
                Icon(
                  Icons.favorite_rounded,
                  size: 80,
                  color: Colors.purple[600],
                ),
                SizedBox(height: 20),
                // Short and sweet message
                Text(
                  'Your thoughts mean a lot to us. We strive to improve based on your feedback.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.purple[700],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                // Back to Home button
                ElevatedButton(
                  onPressed: () {
                    // Get the current user from Firebase Authentication
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      String userId = user.uid; // Get userId (uid)
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(), // Pass userId to HomePage
                        ),
                            (route) => false, // Removes all previous routes
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[400], // Light purple color for button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 32.0,
                    ),
                  ),
                  child: Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
