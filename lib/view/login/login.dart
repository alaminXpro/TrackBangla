import 'package:provider/provider.dart';
import 'package:trackbangla/blocs/internet_bloc.dart';
import 'package:trackbangla/blocs/sign_in_bloc.dart';
import 'package:trackbangla/core/constants/colors.dart';
import 'package:trackbangla/core/utils/next_screen.dart';
import 'package:trackbangla/core/utils/responsive_size.dart';
import 'package:trackbangla/core/utils/snacbar.dart';
import 'package:trackbangla/pages/done.dart';
import 'package:trackbangla/router/app_routes.dart';
import 'package:trackbangla/view/login/controller/login_controller.dart';
import 'package:trackbangla/widgets/text_field.dart';
import 'package:trackbangla/widgets/button.dart';
import 'package:trackbangla/widgets/outlined_button.dart';
import 'package:trackbangla/widgets/title_text.dart';
import 'package:trackbangla/widgets/top_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final LoginController controller = Get.find();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool googleSignInStarted = false;
  handleGoogleSignIn() async{
    final sb = context.read<SignInBloc>();
    final ib = context.read<InternetBloc>();
    setState(() =>googleSignInStarted = true);
    await ib.checkInternet();
    if(ib.hasInternet == false){
      openSnacbar(scaffoldKey, 'check your internet connection!'.tr);
      
    }else{
      await sb.signInWithGoogle().then((_){
        if(sb.hasError == true){
          openSnacbar(scaffoldKey, 'something is wrong. please try again.'.tr);
          setState(() =>googleSignInStarted = false);

        }else {
          sb.checkUserExists().then((value){
          if(value == true){
            sb.getUserDatafromFirebase(sb.uid)
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.guestSignout())
            .then((value) => sb.setSignIn()
            .then((value){
              setState(() =>googleSignInStarted = false);
              afterSignIn();
            })));
          } else{
            sb.getJoiningDate()
            .then((value) => sb.saveToFirebase()
            .then((value) => sb.increaseUserCount())
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.guestSignout()
            .then((value) => sb.setSignIn()
            .then((value){
              setState(() => googleSignInStarted = false);
              afterSignIn();
            })))));
          }
            });
          
        }
      });
    }
  }

  afterSignIn (){
      nextScreen(context, DonePage());
  }
  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    String title = "Login";
    String imgPath = "assets/images/login.png";
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopImage(
              imgPath: imgPath,
              size: Responsive.horizontalSize(360 * 0.67),
            ),
            TitleText(title: title),
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
              height: Responsive.verticalSize(20),
            ),
            MyTextField(
              controller: controller.passwordController,
              hintText: "password",
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              width: width * 0.8,
              icon: const Icon(Icons.lock_outline_rounded, size: 19),
              suffixText: "Forgot?",
              onSuffixTap: () => Get.toNamed(AppRoutes.forgot),
            ),
            SizedBox(
              height: Responsive.verticalSize(30),
            ),
            GetBuilder<LoginController>(builder: (cont) {
              return MyButton(
                showCircularBar: cont.isLoading.value,
                onTap: () => cont.login(),
                text: "Login",
              );
            }),
            Padding(
              padding: EdgeInsets.only(
                  top: Responsive.verticalSize(20),
                  bottom: Responsive.verticalSize(20)),
              child: Center(
                child: Text(
                  "Or, login with..",
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => handleGoogleSignIn(),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: googleSignInStarted == false
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google.png',
                          height: 50,
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Text(
                        //   'Sign In with Google',
                        //   style: TextStyle(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w600,
                        //       color: Theme.of(context).primaryColor),
                        // )
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.white),
                    ),
            ),
            SizedBox(
              height: Responsive.verticalSize(20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.signup),
                  child: Text(
                    "Register",
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
    );
  }
}
