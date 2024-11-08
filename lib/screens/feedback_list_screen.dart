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
      appBar: AppBar(title: Text('User Feedback')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('feedbacks').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No feedback available.'));
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
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(feedbackText),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rating: ${rating.toString()} / 5'),
                            if (dateTime != null)
                              Text('Date: ${dateTime.toLocal().toString().split(' ')[0]}'),
                          ],
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
              child: Text('Submit Feedback'),
            ),
          ),
        ],
      ),
    );
  }
}
