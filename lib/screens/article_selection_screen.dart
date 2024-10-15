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
      ),
      body: articles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(articles[index]['title']),
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
          );
        },
      ),
    );
  }
}
