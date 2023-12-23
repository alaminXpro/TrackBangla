//import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:trackbangla/core/constants/colors.dart';
import 'package:trackbangla/core/utils/responsive_size.dart';
import 'package:trackbangla/router/app_routes.dart';
import 'package:trackbangla/view/signup/controller/signup_controller.dart';
import 'package:trackbangla/widgets/text_field.dart';
import 'package:trackbangla/widgets/button.dart';
import 'package:trackbangla/widgets/outlined_button.dart';
import 'package:trackbangla/widgets/title_text.dart';
import 'package:trackbangla/widgets/top_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    String title = "Register";
    String imgPath = "assets/images/signup.png";
    final SignUpController controller = Get.find();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              leading: GestureDetector(
                child: const Icon(Icons.arrow_back_ios,
                    color: Colors.grey, size: 16),
                onTap: () => Navigator.of(context).pop(),
              ),
              backgroundColor:
                  Colors.transparent, //You can make this transparent
              elevation: 0.0, //No shadow
            ),
          ),
          SingleChildScrollView(
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopImage(
                  imgPath: imgPath,
                  size: Responsive.horizontalSize(360 * 0.55),
                ),
                TitleText(title: title),
                SizedBox(
                  height: Responsive.verticalSize(15),
                ),
                MyTextField(
                  controller: controller.nameController,
                  hintText: "name",
                  keyboardType: TextInputType.name,
                  width: width * 0.8,
                  icon: const Icon(FontAwesomeIcons.user, size: 17),
                ),
                SizedBox(
                  height: Responsive.verticalSize(15),
                ),
                MyTextField(
                  controller: controller.emailController,
                  hintText: "email address",
                  keyboardType: TextInputType.emailAddress,
                  width: width * 0.8,
                  icon: const Icon(FontAwesomeIcons.at, size: 17),
                ),
                SizedBox(
                  height: Responsive.verticalSize(15),
                ),
                MyTextField(
                  hintText: "password",
                  controller: controller.passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  width: width * 0.8,
                  icon: const Icon(Icons.lock_outline_rounded, size: 19),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: Responsive.verticalSize(15),
                      bottom: Responsive.verticalSize(15),
                      left: width * 0.1,
                      right: width * 0.1),
                  child: Text.rich(
                    TextSpan(
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text: "By signing up, you're agree to our ",
                            style: GoogleFonts.poppins(),
                          ),
                          TextSpan(
                            text: "Terms & Conditions ",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500, color: mainColor),
                          ),
                          TextSpan(
                            text: "and ",
                            style: GoogleFonts.poppins(),
                          ),
                          TextSpan(
                            text: "Privacy Policy.",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500, color: mainColor),
                          ),
                        ]),
                  ),
                ),
                GetBuilder<SignUpController>(builder: (cont) {
                  return MyButton(
                    showCircularBar: cont.isLoading.value,
                    onTap: () => cont.register(),
                    text: "Register",
                  );
                }),
                Padding(
                  padding: EdgeInsets.only(
                      top: Responsive.verticalSize(15),
                      bottom: Responsive.verticalSize(15)),
                  child: Center(
                    child: Text(
                      "Or, register with..",
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
                MyOutlinedButton(
                    child: Image.asset(
                  "assets/images/google.png",
                )),
                SizedBox(
                  height: Responsive.verticalSize(15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.login),
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(color: mainColor),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Responsive.verticalSize(15),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
