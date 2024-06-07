import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermyappp/conts/colors.dart';
import 'package:fluttermyappp/views/reviews_view/review.dart';

class AddReviewScreen extends StatefulWidget {
  final String employeeId;

  AddReviewScreen({required this.employeeId});

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewerNameController = TextEditingController();
  final _reviewTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReviewerName();
  }

  Future<void> _loadReviewerName() async {
    // Получаем текущего пользователя
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Получаем его ID
      final userId = currentUser.uid;
      // Получаем данные пользователя из Firestore
      final userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final userData = userSnapshot.data();
      if (userData != null) {
        // Получаем полное имя пользователя
        final fullName = userData['fullname'];
        _reviewerNameController.text = fullName;
      }
    }
  }

  void _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final review = Review(
        employeeId: widget.employeeId,
        reviewerName: _reviewerNameController.text,
        reviewText: _reviewTextController.text,
        timestamp: Timestamp.now(),
      );

      await FirebaseFirestore.instance.collection('reviews').add(review.toMap());

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _reviewTextController,
                decoration: InputDecoration(labelText: 'Your Review'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your review';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blueColor,
                foregroundColor: AppColors.whiteColor,
                shape: const StadiumBorder(),
              ),
                onPressed: _submitReview,
                child: Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}