import 'package:flutter/material.dart';

class SummariesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summaries'),
      ),
      body: Center(
        child: Text(
          'Summaries content will be displayed here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}