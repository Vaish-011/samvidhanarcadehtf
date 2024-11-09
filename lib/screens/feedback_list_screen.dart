import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'thank_you_screen.dart';

class FeedbackListScreen extends StatelessWidget {
  // Function to navigate to the ThankYouScreen
  void _navigateToThankYouScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThankYouScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Feedback'),
        backgroundColor: Colors.purple[400], // Light purple color
        elevation: 5,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[50]!,
              Colors.purple[100]!,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('feedbacks').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No feedback available.'));
                  }

                  List<DocumentSnapshot> feedbackDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: feedbackDocs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> feedbackData = feedbackDocs[index].data() as Map<String, dynamic>;
                      String feedbackText = feedbackData['feedback'] ?? 'No text provided';
                      double rating = feedbackData['rating']?.toDouble() ?? 0.0;
                      Timestamp? timestamp = feedbackData['timestamp'];
                      DateTime? dateTime = timestamp != null ? timestamp.toDate() : null;

                      return Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              feedbackText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[800],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rating: ${rating.toString()} / 5',
                                  style: TextStyle(
                                    color: Colors.purple[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (dateTime != null)
                                  Text(
                                    'Date: ${dateTime.toLocal().toString().split(' ')[0]}',
                                    style: TextStyle(
                                      color: Colors.purple[600],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => _navigateToThankYouScreen(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[400], // Light purple color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 32.0,
                  ),
                ),
                child: Text(
                  'Submit Feedback',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
