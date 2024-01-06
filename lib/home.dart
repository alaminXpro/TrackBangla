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
<<<<<<< HEAD
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
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text("name: ", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.5,
                      ),),
                      Text(_user.displayName!)
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "email: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.5,
                          ),
                      ),
                      Text(_user.email!)
                    ],
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
              ),
            );
          }

          return Text("Loading");
        },
      ),
=======
      body: Center(child: Text('Welcome Prince!')),
>>>>>>> alaminxpro
    );
  }
}
