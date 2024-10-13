import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'quiz_screen1.dart';
import '../models/section_model.dart';
import '../models/question_model.dart';

// Load sections from sections.json
Future<List<SectionModel>> loadSections() async {
  String jsonString = await rootBundle.loadString('assets/sections.json');
  List<dynamic> jsonResponse = json.decode(jsonString);
  return jsonResponse.map((data) => SectionModel.fromJson(data)).toList();
}

// Load questions from corresponding section-level JSON files
Future<List<Question>> loadQuestions(String sectionFileName, int levelNumber) async {
  try {
    String jsonString = await rootBundle.loadString('assets/section1.json'); // Dynamically load the correct section file
    List<dynamic> jsonResponse = json.decode(jsonString);

    // Find the questions for the specified level number
    for (var level in jsonResponse) {
      if (level['levelNumber'] == levelNumber) {
        return (level['questions'] as List)
            .map<Question>((data) => Question.fromJson(data))
            .toList();
      }
    }
    return [];
  } catch (e) {
    print('Error loading questions: $e');
    return [];
  }
}

class LevelScreen extends StatefulWidget {
  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  late Future<List<SectionModel>> sections;

  final List<Color> sectionColors = [
    Colors.green[400]!,
    Colors.blue[300]!,
    Colors.red[300]!,
    Colors.orange[300]!,
    Colors.purple[300]!,
    Colors.teal[300]!,
  ];

  @override
  void initState() {
    super.initState();
    sections = loadSections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text(
          'CONSTITUTION',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<SectionModel>>(
        future: sections,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No sections available.'));
          } else {
            final sectionList = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sectionList.map((section) {
                  int index = sectionList.indexOf(section);
                  final Color sectionColor = sectionColors[index % sectionColors.length];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: sectionColor,
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        constraints: BoxConstraints(maxWidth: 400),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.title,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 8),
                            Text(
                              section.description,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: section.height.toDouble(),
                        child: Stack(
                          children: [
                            Positioned(
                              left: section.imagePosition['x']!.toDouble(),
                              top: section.imagePosition['y']!.toDouble(),
                              child: Image.asset(section.imagePath, height: 150, fit: BoxFit.cover),
                            ),
                            ...section.levels.map((level) {
                              return Positioned(
                                left: level.position['x']!.toDouble(),
                                top: level.position['y']!.toDouble(),
                                child: LevelIcon(
                                  icon: _getIconData(level.icon),
                                  onTap: () async {
                                    // Load questions from corresponding section JSON file
                                    final questions = await loadQuestions(
                                        'section${index + 1}.json', level.levelNumber);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizScreen(questions: questions),
                                      ),
                                    );
                                  },
                                  color: sectionColor,
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }

  IconData _getIconData(String icon) {
    switch (icon) {
      case 'star':
        return Icons.star;
      case 'book':
        return Icons.book;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'ac_unit':
        return Icons.ac_unit;
      default:
        return Icons.error;
    }
  }
}

class LevelIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const LevelIcon({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        width: 80,
        height: 80,
        child: Center(child: Icon(icon, color: Colors.white, size: 40)),
      ),
    );
  }
}
