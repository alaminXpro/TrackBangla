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

  RxBool isLoading = false.obs;

  Future<void> register() async {
    isLoading.value = true;
    update();
    try {
      final user = await api.registerUser(
          nameController.text, emailController.text, passwordController.text);
      if (user != null) {
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
