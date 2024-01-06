import 'package:trackbangla/blocs/sign_in_bloc.dart';
import 'package:trackbangla/core/utils/next_screen.dart';
import 'package:trackbangla/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api/api.dart';
import '../../../pages/done.dart';

class LoginController extends GetxController {
  final ApiClient api;

  LoginController(this.api);

  TextEditingController passwordController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  RxBool isLoading = false.obs;
  final sb = Get.find<SignInBloc>();

  Future<void> login() async {
    isLoading.value = true;
    update();
    try {
      final user =
        await api.login(emailController.text, passwordController.text);
      if (user != null) {
        if (user.emailVerified) {
          Get.snackbar('Success', 'Logged in successfully!');
          sb.setSignIn();
          Get.to(DonePage());
        } else {
          Get.snackbar('Error', 'Please verify your email before logging in.');
        }
      } else {
        Get.snackbar('Error', 'Email or password are incorrect');
      }
    } catch (error) {
      // Handle any errors that occurred while creating the user or updating their profile.
      Get.snackbar('error', 'email or password or name are invalid2');
    }
    isLoading.value = false;
    update();
  }
  
}
