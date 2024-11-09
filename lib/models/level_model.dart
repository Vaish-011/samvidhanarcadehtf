class LevelModel {
  final String icon;
  final int levelNumber;
  final Map<String, double> position;

  LevelModel({
    required this.icon,
    required this.levelNumber,
    required this.position,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      icon: json['icon'] as String? ?? 'default_icon',
      levelNumber: json['levelNumber'] as int? ?? 1,
      position: {
        'x': (json['position']?['x'] as num?)?.toDouble() ?? 0.0,
        'y': (json['position']?['y'] as num?)?.toDouble() ?? 0.0,
      },
    );
  }
}


