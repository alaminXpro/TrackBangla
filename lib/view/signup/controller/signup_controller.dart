import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackbangla/blocs/internet_bloc.dart';
import 'package:trackbangla/blocs/sign_in_bloc.dart';
import 'package:trackbangla/router/app_routes.dart';
import '../../../data/api/api.dart';

class SignUpController extends GetxController {
  final ApiClient api;

  SignUpController(this.api);

  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  //TextEditingController phoneController = TextEditingController();

  RxBool isLoading = false.obs;

  Future register() async {
    isLoading.value = true;
    update();
    try {
      final ib = Get.find<InternetBloc>();
      await ib.checkInternet();
      if (ib.hasInternet == false) {
        Get.snackbar("Error", 'check your internet connection!'.tr);
      } else {
        final user = await api.registerUser(
            nameController.text, emailController.text, passwordController.text);
        if (user != null) {
          final sb = Get.find<SignInBloc>();
          //set user data to SignInBloc
          await sb.setName(nameController.text);
          await sb.setEmail(emailController.text);
          await sb.setUid(user.uid);
          await sb.setSignInProvider('email');
          await sb.setImageUrl('https://lh3.googleusercontent.com/a/ACg8ocJXk4BL9mYJGiAWNYLZBTvT21cFmGbAZKx8cF9Z23t7=s96-c');

          await sb.getJoiningDate().then((value) => sb
              .saveToFirebase()
              .then((value) => sb.increaseUserCount()));

          Get.snackbar('Success', 'User registered successfully!');
          Get.toNamed(AppRoutes.login);
        }
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
