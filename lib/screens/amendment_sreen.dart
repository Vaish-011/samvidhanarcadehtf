import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'amendment_screenstate.dart';

class AmendmentsScreen extends StatefulWidget {
  @override
  _AmendmentsScreenState createState() => _AmendmentsScreenState();
}

class _AmendmentsScreenState extends State<AmendmentsScreen> {
  List<dynamic> amendments = [];

  @override
  void initState() {
    super.initState();
    loadAmendments();
  }

  // Load JSON data from assets
  Future<void> loadAmendments() async {
    final String jsonString = await rootBundle.rootBundle.loadString('assets/amendments.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      amendments = jsonData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Amendments'),
      ),
      body: amendments.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: amendments.length,
        itemBuilder: (context, index) {
          final amendment = amendments[index];
          return ListTile(
            title: Text(amendment['title']),
            subtitle: Text("Amendment ${amendment['number']}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AmendmentDetailScreen(
                    amendment: amendment,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
