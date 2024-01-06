import 'package:flutter/material.dart';
import 'package:trackbangla/core/utils/next_screen.dart';
import '/pages/sign_in.dart';
import 'package:easy_localization/easy_localization.dart';

openSignInDialog(context){
   return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx){
        return AlertDialog(
          title: const Text('no sign in title').tr(),
          content: const Text('no sign in subtitle').tr(),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
                nextScreenPopup(context, SignInPage(tag: 'popup',));
              }, 
              child: const Text('sign in').tr()),

              ElevatedButton(
              onPressed: (){
                
                
                Navigator.pop(context);
              }, 
              child: const Text('cancel').tr())
          ],
        );
      }
    );
 }