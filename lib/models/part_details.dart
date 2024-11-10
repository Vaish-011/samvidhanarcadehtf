class PartDetails {
  final int id;
  final String title;
  final String content;  // Change 'description' to 'content'

  PartDetails({required this.id, required this.title, required this.content});

  factory PartDetails.fromJson(Map<String, dynamic> json) {
    return PartDetails(
      id: json['id']is String ? int.parse(json['id']) : json['id'],
      title: json['title'],
      content: json['content'],  // Map 'content' from the JSON
    );
  }
}
