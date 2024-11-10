import 'package:flutter/material.dart';
import 'article_screen.dart';  // Make sure this import is here

class BookmarkedArticlesScreen extends StatelessWidget {
  final List<int> bookmarkedArticles; // List of bookmarked article indices
  final List<dynamic> articles; // List of all articles

  BookmarkedArticlesScreen({required this.bookmarkedArticles, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Articles'),
      ),
      body: bookmarkedArticles.isEmpty
          ? Center(child: Text('No bookmarked articles'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: bookmarkedArticles.length,
        itemBuilder: (context, index) {
          final article = articles[bookmarkedArticles[index]];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              title: Text(
                article['title'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7B1FA2),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleScreen(
                      title: article['title'],
                      content: article['content'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
