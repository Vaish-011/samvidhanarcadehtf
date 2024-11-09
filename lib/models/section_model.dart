import 'level_model.dart';

class SectionModel {
  final String title;
  final String description;
  final String imagePath;
  final double height;
  final Map<String, double> imagePosition;
  final List<LevelModel> levels;

  SectionModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.height,
    required this.imagePosition,
    required this.levels,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      title: json['title'] as String? ?? 'Default Title',
      description: json['description'] as String? ?? 'Default Description',
      imagePath: json['imagePath'] as String? ?? '',
      height: (json['height'] as num?)?.toDouble() ?? 150.0,
      imagePosition: {
        'x': (json['imagePosition']?['x'] as num?)?.toDouble() ?? 0.0,
        'y': (json['imagePosition']?['y'] as num?)?.toDouble() ?? 0.0,
      },
      levels: (json['levels'] as List<dynamic>)
          .map((level) => LevelModel.fromJson(level))
          .toList(),
    );
  }
}
