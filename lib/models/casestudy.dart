class Casestudy {
  final String title;
  final String description;
  final String url;

  Casestudy({required this.title, required this.url, required this.description});

  // Method to convert JSON to a Casestudy object
  factory Casestudy.fromJson(Map<String, dynamic> json) {
    return Casestudy(
      title: json['title'],
      description: json['description'],
      url: json['url'],
    );
  }
}
