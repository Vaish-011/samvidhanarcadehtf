import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/podcast.dart';

class PodcastService {
  Future<List<Podcast>> loadPodcasts() async {
    // Load JSON data from the assets
    final String response = await rootBundle.loadString('assets/podcasts.json');
    final List<dynamic> data = json.decode(response);


    return data.map((json) => Podcast.fromJson(json)).toList();
  }
}
