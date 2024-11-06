class Podcast {
  final String title;
  final String url;
  final String description;

  Podcast({required this.title, required this.url, required this.description});

  // Method to convert JSON to a Podcast object
  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      title: json['title'],
      url: json['url'],
      description: json['description'],
    );
  }
}
