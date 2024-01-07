// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:trackbangla/blocs/sign_in_bloc.dart';

// class LoginController with ChangeNotifier {
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   set isLoading(bool isLoading) {
//     _isLoading = isLoading;
//     notifyListeners();
//   }

//   Future<void> login() async {
//     final sb = context.read<SignInBloc>();
//     isLoading = true;
//     try {
//       final user = await sb.signInWithEmail(emailController.text, passwordController.text);
//       if (user != null) {
//         if (user.emailVerified) {
//           // Navigate to DonePage
//         }
//       }
//     } finally {
//       isLoading = false;
//     }
//   }
// }