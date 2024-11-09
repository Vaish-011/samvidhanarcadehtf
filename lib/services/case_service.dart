import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/casestudy.dart';

class CasestudyService {
  Future<List<Casestudy>> loadCasestudys() async {
    // Load JSON data from the assets
    final String response = await rootBundle.loadString('assets/case_studies.json');
    final Map<String, dynamic> data = json.decode(response);
    final List<dynamic> caseStudiesJson = data["case_studies"];

    return caseStudiesJson.map((json) => Casestudy.fromJson(json)).toList();
  }
}
