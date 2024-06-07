import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermyappp/conts/colors.dart';
import 'package:fluttermyappp/views/reviews_view/review.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



class EmployeeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Employee 1'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.upload),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadImageScreen(employeeId: 'employee1'),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.photo_album),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PortfolioScreen(employeeId: 'employee1'),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeReviewsScreen(employeeId: 'employee1'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Add more employee list items as needed
        ],
      ),
    );
  }
}

class UploadImageScreen extends StatefulWidget {
  final String employeeId;

  UploadImageScreen({required this.employeeId});

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      File file = File(image.path);
      String fileName = '${widget.employeeId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child('portfolioImages/$fileName');

      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('portfolio').add({
        'imageUrl': downloadUrl,
        'uploaderId': widget.employeeId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image uploaded successfully')));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blueColor,
            foregroundColor: AppColors.whiteColor,
            shape: const StadiumBorder(),
          ),
          onPressed: _uploadImage,
          child: Text('Upload Image'),
        ),
      ),
    );
  }
}

class PortfolioScreen extends StatelessWidget {
  final String employeeId;

  PortfolioScreen({required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('portfolio')
            .where('uploaderId', isEqualTo: employeeId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No images found'));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot? doc = snapshot.data!.docs[index];
              if (doc == null || !doc.exists) {
                return SizedBox(); // Пустой контейнер, если данные отсутствуют
              }
              String imageUrl = doc['imageUrl'];

              return Image.network(imageUrl, fit: BoxFit.cover);
            },
          );
        },
      ),
    );
  }
}


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
          backgroundColor: AppColors.blueColor,
          foregroundColor: AppColors.whiteColor,
          shape: const StadiumBorder(),
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

class EmployeeReviewsScreenWithout extends StatelessWidget {
  final String employeeId;

  EmployeeReviewsScreenWithout({required this.employeeId});

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
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddReviewScreen extends StatefulWidget {
  final String employeeId;

  AddReviewScreen({required this.employeeId});

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewTextController = TextEditingController();
  String _reviewerName = ''; // Переменная для хранения имени рецензента

  @override
  void initState() {
    super.initState();
    _loadReviewerName(); // Загрузка имени рецензента при инициализации экрана
  }

  Future<void> _loadReviewerName() async {
    try {
      // Получаем текущего пользователя
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Получаем его ID
        final userId = currentUser.uid;
        // Получаем данные пользователя из Firestore
        final userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        // Получаем имя пользователя из данных
        final fullName = userData['fullname'];
        setState(() {
          _reviewerName = fullName; // Обновляем переменную с именем рецензента
        });
      }
    } catch (e) {
      print('Error loading reviewer name: $e');
    }
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final review = Review(
        employeeId: widget.employeeId,
        reviewerName: _reviewerName, // Используем переменную с именем рецензента
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
