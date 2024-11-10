import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MultilingualMaterialPage extends StatefulWidget {
  @override
  _MultilingualMaterialPageState createState() => _MultilingualMaterialPageState();
}

class _MultilingualMaterialPageState extends State<MultilingualMaterialPage> {
  Future<List<dynamic>> _loadMultilingualMaterials() async {
    final String response = await rootBundle.loadString('assets/multilingual_materials.json');
    return json.decode(response);
  }

  // Function to open the PDF link
  Future<void> _launchPDF(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multilingual Materials'),
        backgroundColor: Color(0xFF26A69A), // Teal color for AppBar
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _loadMultilingualMaterials(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final material = snapshot.data![index];
                return _buildPDFCard(context, material['title'], material['description'], material['url']);
              },
            );
          }
        },
      ),
    );
  }

  // Function to create a card for each item in JSON
  Widget _buildPDFCard(BuildContext context, String title, String description, String url) {
    return GestureDetector(
      onTap: () => _launchPDF(url),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Smooth rounded corners
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFB2DFDB), // Light Teal
                Color(0xFF80CBC4), // Slightly darker teal
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                offset: Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.picture_as_pdf,
                size: 50,
                color: Color(0xFF004D40), // Dark teal for PDF icon
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
