import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermyappp/controllers/auth_controller.dart';
import 'package:fluttermyappp/controllers/settings_controller.dart';
import 'package:fluttermyappp/conts/conts.dart';
import 'package:fluttermyappp/views/login_view/login_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Future<void> _changeAvatar(BuildContext context, SettingsController controller) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref().child('avatars/${controller.userId.value}.jpg');

      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore
      await FirebaseFirestore.instance.collection('users').doc(controller.userId.value).update({
        'avatarUrl': downloadUrl,
      });

      // Update controller
      controller.avatarUrl.value = downloadUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SettingsController());
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: AppStyles.bold(title: AppStrings.settings, color: AppColors.whiteColor, size: AppSizes.size18),
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
                  backgroundImage: controller.avatarUrl.value.isNotEmpty
                      ? NetworkImage(controller.avatarUrl.value)
                      : AssetImage(AppAssets.icLogin) as ImageProvider,
                ),
              ),
              title: AppStyles.bold(title: controller.username.value),
              subtitle: AppStyles.normal(title: controller.email.value),
            ),
            const Divider(),
            10.heightBox,
            ListView(
              shrinkWrap: true,
              children: List.generate(
                settingsListUsers.length,
                    (index) => ListTile(
                  onTap: () async {
                    if (index == 0) {
                      AuthController().signout();
                      Get.offAll(() => const LoginView());
                    }
                  },
                  leading: Icon(
                    settingsListIconUsers[index],
                    color: AppColors.blueColor,
                  ),
                  title: AppStyles.bold(
                    title: settingsListUsers[index],
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
