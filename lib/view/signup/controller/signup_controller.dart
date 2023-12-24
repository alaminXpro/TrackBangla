import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackbangla/router/app_routes.dart';

import '../../../data/api/api.dart';

class SignUpController extends GetxController {
  final ApiClient api;

  SignUpController(this.api);

  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> register() async {
  isLoading.value = true;
  update();
  try {
    final user = await api.registerUser(
        nameController.text, emailController.text, passwordController.text);
    if (user != null) {
      //Add the user to the Firestore database
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      });

      Get.snackbar('Success', 'User registered successfully!');
      Get.toNamed(AppRoutes.login);
    }
  } on EmailAlreadyInUseException {
    Get.snackbar('Error', 'User already exists, please login.');
  } catch (error) {
    Get.snackbar('Error', 'An unknown error occurred.');
  }
  isLoading.value = false;
  update();
}
}
