import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsController extends GetxController {
  var isLoading = true.obs;
  var username = ''.obs;
  var email = ''.obs;
  var avatarUrl = ''.obs;
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      isLoading(true);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId.value = user.uid;
        var userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        username.value = userData['fullname'];
        email.value = userData['email'];
        avatarUrl.value = userData['avatarUrl'];
      }
    } finally {
      isLoading(false);
    }
  }
}
