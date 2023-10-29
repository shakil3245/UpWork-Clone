import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../widgets/button.dart';
import 'ForgetPassword.dart';
import 'SignUpScreen.dart';
import '../pages/bottomNavigationBar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loginProgress = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> _signIn() async {
    try {
      setState(() {
        _loginProgress = true;
      });
      final credential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
      );
      if(credential.user!.uid.isNotEmpty){
        Navigator.push(context, CupertinoPageRoute(builder: (_)=>BottomNavBar()));
      }else{
        Fluttertoast.showToast(msg: "Something went Worng!");
      };
      setState(() {
        _loginProgress = false;
      });
      // Navigator.canPop(context) ? Navigator.pop(context):null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "No user found for that email.");

      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong password provided for that user.");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 200,child:Image.asset('assets/images/job-application.png',),),
              SizedBox(height: 30,),
              TextFormField(
                controller: _emailController,
                validator: (value){
                  if(value!.isEmpty){
                    return "please enter Email";
                  }else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                    hintText: "Email..", border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10,
              ),

              TextFormField(
                controller: _passwordController,

                validator: (value){
                  if(value!.isEmpty){
                    return "please enter Password";
                  }else{
                    return null;
                  }
                },
                obscureText:true,
                decoration: InputDecoration(
                    hintText: "Password..",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye_outlined),
                      onPressed: () {

                      },
                    ),
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {Get.to(ForgetPassword());}, child: Text("Forget Password?")),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(child:_loginProgress?Center(child: CircularProgressIndicator(),):Btn(name: 'Login', onPress: () { _signIn(); },)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't Have and Account?"),
                  TextButton(
                      onPressed: () {
                       Get.to(const SignUp());
                      },
                      child: Text(
                        "Sign Up",
                        style:
                            TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

