import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttermyappp/controllers/auth_controller.dart';
import 'package:fluttermyappp/controllers/settings_emp_controller.dart';
import 'package:fluttermyappp/conts/conts.dart';
import 'package:fluttermyappp/views/login_view/login_view.dart';
import 'package:fluttermyappp/views/reviews_view/emp_list_screen.dart'; // Импорт экрана отзывов
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsEmpView extends StatelessWidget {
  const SettingsEmpView({super.key});

  Future<void> _changeAvatar(BuildContext context, SettingsEmpController controller) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref().child('avatars/${controller.empID.value}.jpg');

      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore
      await FirebaseFirestore.instance.collection('employees').doc(controller.empID.value).update({
        'avatarUrl': downloadUrl,
      });

      // Update controller
      controller.empAvatarUrl.value = downloadUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SettingsEmpController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: AppStyles.bold(
          title: AppStrings.settings,
          color: AppColors.whiteColor,
          size: AppSizes.size18,
        ),
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () => _changeAvatar(context, controller),
                child: CircleAvatar(
                  backgroundImage: controller.empAvatarUrl.value.isNotEmpty
                      ? NetworkImage(controller.empAvatarUrl.value)
                      : AssetImage(AppAssets.icLogin) as ImageProvider,
                ),
              ),
              title: AppStyles.bold(
                title: controller.empName.value,
              ),
              subtitle: AppStyles.normal(
                title: controller.empEmail.value,
              ),
            ),
            const Divider(),
            10.heightBox,
            ListView(
              shrinkWrap: true,
              children: List.generate(settingsList.length, (index) {
                return ListTile(
                  onTap: () async {
                    if (index == 3) {
                      AuthController().signout();
                      Get.offAll(() => const LoginView());
                    } else if (index == 2) { // Переход в EmployeeReviewsScreen под индексом 1
                      var employeeId = controller.empID.value;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployeeReviewsScreenWithout(employeeId: employeeId),
                        ),
                      );
                    } else if (index == 0) { // Переход в окно загрузки фотографий под индексом 0
                      var employeeId = controller.empID.value;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadImageScreen(employeeId: employeeId),
                        ),
                      );
                    } else if (index == 1) { // Переход в окно просмотра загруженных фотографий под индексом 3
                      var employeeId = controller.empID.value;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PortfolioScreen(employeeId: employeeId),
                        ),
                      );
                    }
                  },
                  leading: Icon(
                    settingsListIcon[index],
                    color: AppColors.blueColor,
                  ),
                  title: AppStyles.bold(
                    title: settingsList[index],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}