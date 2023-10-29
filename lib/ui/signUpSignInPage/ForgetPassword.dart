import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upworkclone/ui/signUpSignInPage/LoginScreen.dart';

import '../../stateManagement/userSate.dart';
import '../../widgets/button.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  TextEditingController _forgetPasswordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

//forget passord fucntion
  Future<void> _forgetPassword() async {
      try{
        await _auth.sendPasswordResetEmail(email:_forgetPasswordController.text );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const UserSate()));
      }catch(e){
        Fluttertoast.showToast(msg: e.toString());
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Forget Password?',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
            SizedBox(height: 12,),
            TextFormField(
              controller: _forgetPasswordController,
              decoration: InputDecoration(
                  hintText: "Email Address",
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 20,),
            Btn(name: 'Reset Now', onPress: () { _forgetPassword(); },)
          ],),
        ),
      ),
    );
  }
}
