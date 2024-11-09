class PartDetails {
  final String title;
  final String content;

  PartDetails({required this.title, required this.content});

  // Factory constructor to create an object from JSON data
  factory PartDetails.fromJson(Map<String, dynamic> json) {
    return PartDetails(
      title: json['title'],
      content: json['content'],
    );
  }
}
