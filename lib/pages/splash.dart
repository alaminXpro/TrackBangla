import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackbangla/home.dart';
import 'package:trackbangla/widgets/WelcomePage.dart';
import '/blocs/sign_in_bloc.dart';
import '/core/config/config.dart';
import '/pages/sign_in.dart';
//import '/pages/home.dart';
import '/core/utils/next_screen.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin{

  late AnimationController _controller;



  afterSplash(){
    final SignInBloc sb = context.read<SignInBloc>();
    Future.delayed(Duration(milliseconds: 1500)).then((value){
      sb.isSignedIn == true || sb.guestUser == true 
      ? gotoHomePage()
      : gotoSignInPage();
      
    });
  }


  gotoHomePage () {
    final SignInBloc sb = context.read<SignInBloc>();
    if(sb.isSignedIn == true){ 
      sb.getDataFromSp();
    }
    nextScreenReplace(context, Home()); //Homepage hobe
  }




  gotoSignInPage (){
    nextScreenReplace(context, SignInPage(tag: '',));
  }




  

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _controller.forward();
    afterSplash();
  }






  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }









  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: RotationTransition(

              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: Image(
                image: AssetImage(Config().splashIcon),
                height: 120,
                width: 120,
                fit: BoxFit.contain,
              )
            ),
    ));
  }
}
