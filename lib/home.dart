import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackbangla/data/api/api.dart';
import 'package:trackbangla/router/app_routes.dart';

class Home extends StatelessWidget {
  final User user;
  const Home({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.reset),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              await Get.find<ApiClient>().logout();
              Get.snackbar('Success', 'Logged out successfully!');
              Get.toNamed(AppRoutes.login);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [const Text("name: "), Text(user.displayName!)],
          ),
          Row(
            children: [const Text("email: "), Text(user.email!)],
          ),
          Row(
            children: [
              const Text("is email verified: "),
              // Text(user.emailVerified??.toString())
            ],
          ),
        ],
      ),
    );
  }
}
