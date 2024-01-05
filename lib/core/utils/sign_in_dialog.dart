import 'package:flutter/material.dart';
import 'package:trackbangla/core/utils/next_screen.dart';
//import 'pages/sign_in.dart';
import 'package:easy_localization/easy_localization.dart';

openSignInDialog(context){
   return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx){
        return AlertDialog(
          title: Text('no sign in title').tr(),
          content: Text('no sign in subtitle').tr(),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
                //nextScreenPopup(context, SignInPage(tag: 'popup',));
              }, 
              child: Text('sign in').tr()),

              ElevatedButton(
              onPressed: (){
                
                
                Navigator.pop(context);
              }, 
              child: Text('cancel').tr())
          ],
        );
      }
    );
 }