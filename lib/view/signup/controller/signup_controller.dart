import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final user = await api.registerUser(
        nameController.text, emailController.text, passwordController.text);
    if (user != null) {
      final sb = Get.find<SignInBloc>();
      //set user data to SignInBloc
      sb.setName(nameController.text);
      sb.setEmail(emailController.text);
      sb.setUid(user.uid);
      sb.setSignInProvider('email');
      sb.setImageUrl('https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png');

      sb.getJoiningDate()
            .then((value) => sb.saveToFirebase()
            .then((value) => sb.increaseUserCount())
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.guestSignout()
            .then((value) => sb.setSignIn()
            ))));

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
