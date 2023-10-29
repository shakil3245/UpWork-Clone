import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upworkclone/stateManagement/userSate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 2),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserSate()));
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [
      SizedBox(height: 180,),
      Container(height: 300,child: Image.asset('assets/images/job-interview.png'),),
      SizedBox(height: 220,),
      Text("Job Hunt",style: GoogleFonts.nosifer(
        textStyle: TextStyle(color: Color(0xff1d32d8), letterSpacing: .5,fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,fontSize: 15),
      ),)
    ],),);
  }
}
