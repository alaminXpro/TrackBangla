import 'package:trackbangla/pages/splash.dart';
import 'package:trackbangla/view/forgot_password/forgot.dart';
import 'package:trackbangla/view/login/login.dart';
import 'package:trackbangla/view/reset_password/reset_password.dart';
import 'package:trackbangla/view/signup/signup.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String login = '/login';

  static String signup = '/signup';

  static String reset = '/reset';

  static String forgot = '/forgot';

  static String onBoarding = '/onBoarding';

  static List<GetPage> pages = [
    GetPage(
      name: login,
      page: () => const Login(),
    ),
    GetPage(
      name: signup,
      page: () => const SignUp(),
    ),
    GetPage(
      name: forgot,
      page: () => const ForgotPassword(),
    ),
    GetPage(
      name: reset,
      page: () => const ResetPassword(),
    ),
    GetPage(
      name: onBoarding,
      page: () => const SplashPage(),
    )
  ];
}
