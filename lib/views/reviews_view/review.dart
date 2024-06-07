import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String employeeId;
  final String reviewerName;
  final String reviewText;
  final Timestamp timestamp;

  Review({
    required this.employeeId,
    required this.reviewerName,
    required this.reviewText,
    required this.timestamp,
  });

  factory Review.fromDocument(DocumentSnapshot doc) {
    return Review(
      employeeId: doc['employeeId'],
      reviewerName: doc['reviewerName'],
      reviewText: doc['reviewText'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'reviewerName': reviewerName,
      'reviewText': reviewText,
      'timestamp': timestamp,
    };
  }
}
