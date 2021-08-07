import 'package:easy_mall_shop/screens/landing_page.dart';
import 'package:easy_mall_shop/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if(userSnapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else if (userSnapshot.connectionState == ConnectionState.active){
            if(userSnapshot.hasData){
              print("The user is already logged in");
              return MainScreens();
            }else{
              print("The user did not login yet");
              return LandingPage();
            }
        }else if(userSnapshot.hasError){
            return Center(
              child: Text('Error occurred'),
            );
        }
      }
    );
  }
}