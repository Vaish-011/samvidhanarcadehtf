import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/casestudy.dart';
import '../services/case_service.dart';

class CasestudyListScreen extends StatefulWidget {
  @override
  _CasestudyListScreenState createState() => _CasestudyListScreenState();
}

class _CasestudyListScreenState extends State<CasestudyListScreen> {
  final CasestudyService _casestudyService = CasestudyService();
  List<Casestudy> _casestudies = [];

  @override
  void initState() {
    super.initState();
    _loadCasestudy();
  }

  Future<void> _loadCasestudy() async {
    try {
      List<Casestudy> casestudies = await _casestudyService.loadCasestudys();
      setState(() {
        _casestudies = casestudies;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load case studies. Please try again later.")),
      );
    }
  }

  Future<void> _launchURL(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    final Uri uri = Uri.parse(url);
    try {
      bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
      if (!launched) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open the link. Please try again later.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Case Studies on Constitution of India',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.6),
                offset: Offset(3, 3),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.purple[300],
        centerTitle: true,
      ),
      body: _casestudies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _casestudies.length,
        itemBuilder: (context, index) {
          final caseStudy = _casestudies[index];

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(2, 2),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple[50]!,
                      Colors.purple[100]!,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                // Wrap the Column with SingleChildScrollView
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.article, size: 40, color: Colors.purple[600]),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  caseStudy.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[800],
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.6),
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  caseStudy.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.purple[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => _launchURL(caseStudy.url),
                        child: Text(
                          caseStudy.url,
                          style: TextStyle(
                            color: Colors.purple[600],
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
