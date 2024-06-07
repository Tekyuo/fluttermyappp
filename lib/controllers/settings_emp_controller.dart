import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsEmpController extends GetxController {
  var isLoading = true.obs;
  var empName = ''.obs;
  var empEmail = ''.obs;
  var empAvatarUrl = ''.obs;
  var empID = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadEmpData();
  }

  void _loadEmpData() async {
    try {
      isLoading(true);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        empID.value = user.uid;
        var empData = await FirebaseFirestore.instance.collection('employees').doc(user.uid).get();
        empName.value = empData['empName'];
        empEmail.value = empData['empEmail'];
        empAvatarUrl.value = empData['avatarUrl'];
      }
    } finally {
      isLoading(false);
    }
  }
}
