// models/schedule.dart
class Schedule {
  final String title;
  final List<String> details;

  Schedule({required this.title, required this.details});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      title: json['title'],
      details: List<String>.from(json['details']),
    );
  }
}
