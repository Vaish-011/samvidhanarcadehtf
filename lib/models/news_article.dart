// lib/models/news_article.dart

class NewsArticle {
  final String title;
  final String description;
  final String url;

  NewsArticle({required this.title, required this.description, required this.url});

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      url: json['url'] ?? '',
    );
  }
}
