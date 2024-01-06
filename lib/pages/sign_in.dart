import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackbangla/router/app_routes.dart';
import 'package:trackbangla/widgets/button.dart';
import '/blocs/internet_bloc.dart';
import '/blocs/sign_in_bloc.dart';
import '/core/config/config.dart';
import '/pages/done.dart';
import '/core/utils/next_screen.dart';
import '/core/utils/snacbar.dart';
import 'package:easy_localization/easy_localization.dart';
import '/widgets/language.dart';



class SignInPage extends StatefulWidget {

  final String tag;
  SignInPage({Key? key, required this.tag}) : super(key: key);

  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool googleSignInStarted = false;

  var scaffoldKey = GlobalKey<ScaffoldState>();


  handleSkip (){
    final sb = context.read<SignInBloc>();
    sb.setGuestUser();
    nextScreen(context, DonePage());
    
  }


  handleGoogleSignIn() async{
    final sb = context.read<SignInBloc>();
    final ib = context.read<InternetBloc>();
    setState(() =>googleSignInStarted = true);
    await ib.checkInternet();
    if(ib.hasInternet == false){
      openSnacbar(scaffoldKey, 'check your internet connection!'.tr());
      
    }else{
      await sb.signInWithGoogle().then((_){
        if(sb.hasError == true){
          openSnacbar(scaffoldKey, 'something is wrong. please try again.'.tr());
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
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        actions: [
          widget.tag == 'onBoarding'
              ? Container()
              : ElevatedButton(
                  onPressed: () => handleSkip(),
                  child: Text('Guest',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      )).tr()),

          IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.all(0),
            iconSize: 22,
            icon: Icon(Icons.language,),
            onPressed: (){
              nextScreenPopup(context, LanguagePopup());
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'welcome to',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey[700]),
                  ).tr(),
                  SizedBox(height: 5,),
                  Text(
                    '${Config().appName}',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[700]
                    ),
                  ),
                ],
              )),
          Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      'welcome message',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700]),
                    ).tr(),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width * 0.50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(40)),
                  ),
                ],
              )),
          Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(
                    text: "Sign in with Email",
                    onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: ElevatedButton(
                        onPressed: () => handleGoogleSignIn(),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
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
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Sign In with Google',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor),
                                  )
                                ],
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: Colors.white),
                              )),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05)
                ],
              )),
        ],
      ),
    );
  }



  
}
