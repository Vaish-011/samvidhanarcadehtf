import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'StateDetailScreen.dart';

class StatesScreen extends StatefulWidget {
  @override
  _StatesScreenState createState() => _StatesScreenState();
}

class _StatesScreenState extends State<StatesScreen> {
  List<dynamic> statesData = [];

  @override
  void initState() {
    super.initState();
    loadStatesData();
  }

  Future<void> loadStatesData() async {
    final String response = await rootBundle.loadString('assets/states.json');
    final data = json.decode(response);
    setState(() {
      statesData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('States of India'),
        backgroundColor: Color(0xFFF5F5F5),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: statesData.length,
        itemBuilder: (context, index) {
          final state = statesData[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StateDetailScreen(
                    stateName: state['name'],
                    schedule: state['schedule'],
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF6CC4A1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Text(
                  state['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


