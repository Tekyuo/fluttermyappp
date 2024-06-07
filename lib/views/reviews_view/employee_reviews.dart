import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermyappp/views/reviews_view/review.dart';

import '../../conts/conts.dart';
import 'add_review.dart';

class EmployeeReviewsScreen extends StatelessWidget {
  final String employeeId;

  EmployeeReviewsScreen({required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .where('employeeId', isEqualTo: employeeId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No reviews found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              Review review = Review.fromDocument(doc);

              return ListTile(
                title: Text(review.reviewerName),
                subtitle: Text(review.reviewText),
                trailing: Text(
                  review.timestamp.toDate().toString(),
                  style: TextStyle(color: Colors.blue),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReviewScreen(employeeId: employeeId)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
