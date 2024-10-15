import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'article_screen.dart'; // Import the Article Screen

class ArticleSelectionScreen extends StatefulWidget {
  @override
  _ArticleSelectionScreenState createState() => _ArticleSelectionScreenState();
}

class _ArticleSelectionScreenState extends State<ArticleSelectionScreen> {
  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    String data = await rootBundle.loadString('assets/articles.json');
    setState(() {
      articles = json.decode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select an Article'),
        backgroundColor: Color(0xFFB39DDB), // Match the AppBar color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.9), // Soft white
              Color(0xFFE1BEE7).withOpacity(0.8), // Lighter purple
            ],
          ),
        ),
        child: articles.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4, // Shadow effect for the card
              margin: const EdgeInsets.symmetric(vertical: 8.0), // Space between cards
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              child: ListTile(
                title: Text(
                  articles[index]['title'],
                  style: TextStyle(
                    fontSize: 18, // Font size for the article title
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2), // Match text color with the theme
                  ),
                ),
                tileColor: Colors.white, // Background color for the tile
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleScreen(
                        title: articles[index]['title'],
                        content: articles[index]['content'],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
