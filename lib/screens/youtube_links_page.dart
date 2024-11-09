import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';  // For JSON decoding
import 'package:flutter/services.dart';  // For loading asset files

class YoutubeLinksPage extends StatefulWidget {
  @override
  _YoutubeLinksPageState createState() => _YoutubeLinksPageState();
}

class _YoutubeLinksPageState extends State<YoutubeLinksPage> {
  List<Map<String, String>> youtubePlaylists = [];

  // Method to load and parse the JSON file
  Future<void> loadPlaylists() async {
    final String response = await rootBundle.loadString('assets/playlists.json');
    final data = json.decode(response) as List<dynamic>;  // Casting as List<dynamic> first
    setState(() {
      youtubePlaylists = data.map((playlist) {
        return {
          'title': playlist['title'] as String,  // Ensure that we cast it to String
          'url': playlist['url'] as String,      // Ensure that we cast it to String
        };
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadPlaylists();  // Load the playlists when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Playlists'),
        backgroundColor: Color(0xFFE0F2F1), // Light Teal color for AppBar
        elevation: 0, // Remove shadow for a cleaner look
      ),
      body: youtubePlaylists.isEmpty
          ? Center(child: CircularProgressIndicator())  // Show a loading indicator while data is being loaded
          : Container(
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
            stops: [0.0, 0.33, 0.67, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Space from the edges
          child: ListView.builder(
            itemCount: youtubePlaylists.length,
            itemBuilder: (context, index) {
              final playlist = youtubePlaylists[index];
              return Column(
                children: [
                  _buildPlaylistCard(context, playlist['title']!, playlist['url']!),
                  SizedBox(height: 20), // Space between cards
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistCard(BuildContext context, String title, String url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Card(
        elevation: 6, // Higher elevation for more emphasis
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners for a modern look
        ),
        color: Color(0xFFE0F2F1), // Light Teal color for the card background
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(
                Icons.play_circle_fill,
                color: Colors.teal[800],
                size: 40,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 22, // Large font size for better readability
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Dark color for text contrast
                  ),
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.teal[800]),
            ],
          ),
        ),
      ),
    );
  }
}