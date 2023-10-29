import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upworkclone/ui/signUpSignInPage/LoginScreen.dart';
import 'package:upworkclone/ui/pages/bottomNavigationBar.dart';
import 'package:upworkclone/ui/pages/HomeScreen.dart';

class UserSate extends StatefulWidget {
  const UserSate({Key? key}) : super(key: key);

  @override
  State<UserSate> createState() => _UserSateState();
}

class _UserSateState extends State<UserSate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.data == null) {
            log("User is not log in");
            return LoginScreen();
          }
          else if (userSnapshot.hasError) {
            return Scaffold(
              body: Text("A error has been occurred. Try again latter"),
            );
          }
          else if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return BottomNavBar();
        });
  }
}
