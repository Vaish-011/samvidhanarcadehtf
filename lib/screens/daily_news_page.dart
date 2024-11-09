import 'package:flutter/material.dart';
import 'news_screen.dart'; // Ensure this is the correct import

class DailyNewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NewsScreen(),  // Directly display the NewsScreen content without an AppBar
    );
  }
}
