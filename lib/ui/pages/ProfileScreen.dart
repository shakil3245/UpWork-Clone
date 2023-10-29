import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? userImage;
  String? userEmail;
  String? userPhone;
  String? userLocation;

  Future<void> getProfileData() async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    // final User? user = _auth.currentUser;
    // final _uid = user!.uid;
    final DocumentSnapshot userProfileData = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();

    if (userProfileData == null) {
      return;
    } else {
      setState(() {
        userName = userProfileData.get("name");
        userImage = userProfileData.get("userImage");
        userEmail = userProfileData.get("email");
        userPhone = userProfileData.get("phoneNumber");
        userLocation = userProfileData.get("location");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(color: Color(0xFF091fce),borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.only(top: 50 ),
              child: Column(children: [
                InkWell(
                  child: Center(child: CircleAvatar( backgroundImage: NetworkImage(userImage==null? "Unknown User":userImage!,),
                    radius: 60,),
                  ),onTap: (){},
                ),
                SizedBox(height: 10,),
                Text( userName==null? "":userName!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
              ],),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Account Information",
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(children: [
              Row(
                children: [
                  Icon(Icons.mail),
                  SizedBox(
                    width: 10,
                  ),
                  Text(userEmail == null ? "" : userEmail!),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.call),
                  SizedBox(
                    width: 10,
                  ),
                  Text(userPhone == null ? "" : userPhone!),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_city),
                  SizedBox(
                    width: 10,
                  ),
                  Text(userLocation == null ? "" : userLocation!),
                ],
              ),
            ],),
          ),
          SizedBox(
            height: 20,
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXjEvvLvYr01bE7eQ7QaFsEDEMd3eNzeBH3w&usqp=CAU"),
                ),
                onTap: () {},
              ),
              InkWell(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ92XZSrDH5a67gC2b5cmAbVsU8A3LBR_oOfA&usqp=CAU"),
                ),
                onTap: () {},
              ),
              InkWell(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN03QTVJlTZKNC7Cpq94Z4kjeI-CO28Iv4mw&usqp=CAU"),
                ),
                onTap: () {},
              )
            ],
          )
        ],
      ),
    );
  }
}
