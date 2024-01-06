import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:trackbangla/blocs/sign_in_bloc.dart';
import 'package:trackbangla/core/utils/initial_bindings.dart';
import 'package:trackbangla/core/utils/next_screen.dart';
import 'package:trackbangla/data/api/api.dart';
import 'package:trackbangla/pages/sign_in.dart';
import 'package:trackbangla/router/app_routes.dart';
import 'package:trackbangla/widgets/mydrawer.dart';

// Custom home page
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
            onPressed: ()async{
                Navigator.pop(context);
                await context.read<SignInBloc>().userSignout()
                .then((value) => nextScreenCloseOthers(context, SignInPage(tag: '',)));
                InitialBindings initialBindings = InitialBindings();
                initialBindings.dependencies();
              },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: Center(child: Text('Welcome Prince!')),
    );
  }
}
