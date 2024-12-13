// lib/services/news_service.dart
// 915e44469bf74742b49fdae2710b4ac0

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsService {
  final String apiKey = '/*Add Your API Key here*/';
  final String apiUrl =
      'https://newsapi.org/v2/everything?q=constitution%20of%20india&language=en&apiKey=';

  Future<List<NewsArticle>> fetchConstitutionNews() async {
    try {
      final response = await http.get(Uri.parse(apiUrl + apiKey));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<NewsArticle> newsArticles = [];

        for (var article in data['articles']) {
          if ((article['title'] ?? '').toLowerCase().contains('constitution') ||
              (article['description'] ?? '').toLowerCase().contains('constitution')) {
            newsArticles.add(NewsArticle.fromJson(article));
          }
        }

        return newsArticles;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }
}
