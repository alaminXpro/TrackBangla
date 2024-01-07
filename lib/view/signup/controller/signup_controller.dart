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
          await sb.setImageUrl('https://firebasestorage.googleapis.com/v0/b/trackbangla-faef2.appspot.com/o/avater.png?alt=media&token=e944abc2-08f2-4034-9756-3ffa9299b438');

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
