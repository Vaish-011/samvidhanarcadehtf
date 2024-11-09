import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'feedback_list_screen.dart';

class FeedbackFormScreen extends StatefulWidget {
  @override
  _FeedbackFormScreenState createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0.0;

  Future<void> _submitFeedback() async {
    String feedback = _feedbackController.text;
    if (feedback.isNotEmpty) {
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'feedback': feedback,
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeedbackListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Feedback'),
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'We value your feedback!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _feedbackController,
                          decoration: InputDecoration(
                            labelText: 'Your Feedback',
                            labelStyle: TextStyle(color: Colors.purple[800]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: Colors.purple[800]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: Colors.purple[600]!),
                            ),
                            filled: true,
                            fillColor: Colors.purple[50],
                          ),
                          maxLines: 5,
                          style: TextStyle(color: Colors.purple[800]),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Rate Us:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        const SizedBox(height: 10),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.purple[400],
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _submitFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 32.0,
                            ),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
