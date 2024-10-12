import 'package:flutter/material.dart';

class DailyNewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily News'),
      ),
      body: Center(
        child: Text(
          'Daily News content will be displayed here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}