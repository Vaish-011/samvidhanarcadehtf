import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'article_screen.dart'; // Import the Article Screen
import 'bookmarked_articles_screen.dart'; // Import Bookmarked Articles Screen

class ArticleSelectionScreen extends StatefulWidget {
  @override
  _ArticleSelectionScreenState createState() => _ArticleSelectionScreenState();
}

class _ArticleSelectionScreenState extends State<ArticleSelectionScreen> {
  List<dynamic> articles = [];
  List<int> bookmarkedArticles = []; // List to store bookmarked article indices

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

  // Toggle bookmark for an article
  void _toggleBookmark(int index) {
    setState(() {
      if (bookmarkedArticles.contains(index)) {
        bookmarkedArticles.remove(index);
      } else {
        bookmarkedArticles.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select an Article'),
        backgroundColor: Color(0xFFB39DDB), // Match the AppBar color
        actions: [
          // Bookmark icon in the AppBar to navigate to bookmarked articles
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarkedArticlesScreen(bookmarkedArticles: bookmarkedArticles, articles: articles),
                ),
              );
            },
          ),
        ],
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
                trailing: IconButton(
                  icon: Icon(
                    bookmarkedArticles.contains(index) ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    _toggleBookmark(index);
                  },
                ),
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
