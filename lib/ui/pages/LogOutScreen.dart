import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:upworkclone/ui/signUpSignInPage/LoginScreen.dart';
class LogOut extends StatefulWidget {
  const LogOut({Key? key}) : super(key: key);

  @override
  State<LogOut> createState() => _LogOutState();
}
Future<void> _logOut() async {
  await FirebaseAuth.instance.signOut();
}

class _LogOutState extends State<LogOut> {


  void _dialogue(){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Log Out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _logOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:MainAxisAlignment.center,
      children: [
       Center(
         child: Container(height: 200,width: 200,
         decoration: BoxDecoration(
           color:  Color(0xFF091fce),
           borderRadius: BorderRadius.circular(60),
         ),
         child: TextButton(onPressed: () {
           _dialogue();
           },child: Text("LogOut",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),),),

       )
    ],);
  }
}
