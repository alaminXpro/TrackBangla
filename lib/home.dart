import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackbangla/data/api/api.dart';
import 'package:trackbangla/router/app_routes.dart';
import 'package:trackbangla/widgets/mydrawer.dart';

// Custom home page
class Home extends StatefulWidget {
  final User user;

  const Home({Key? key, required this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late User _user; // Declare _user as an instance variable

  @override
  void initState() {
    super.initState();
    _user = widget.user; // Initialize _user with widget.user during initState
  }

  // SIGN OUT
  void signOut() {
    // FirebaseAuth.instace.signOut();
  }

  // NAVIGATE TO PROFILE PAGE
  void goToProfilePage() {
    // pop menu drawer
  }

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
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(_user.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [const Text("name: "), Text(_user.displayName!)],
                ),
                Row(
                  children: [const Text("email: "), Text(_user.email!)],
                ),
                Row(
                  children: [
                    const Text("is email verified: "),
                    Text(_user.emailVerified.toString())
                  ],
                ),
                Row(
                  children: [const Text("phone: "), Text(data['phone'])],
                ),
              ],
            );
          }

          return Text("Loading");
        },
      ),
    );
  }
}
