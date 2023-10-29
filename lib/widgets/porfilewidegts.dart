
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileWidgets extends StatelessWidget {
  const ProfileWidgets({
    super.key, required this.Image, required this.email, required this.phone, required this.name,
  });
 final String Image;
 final String name;
 final String email;
 final String phone;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          child: Center(child: CircleAvatar( backgroundImage: NetworkImage(Image,),
            radius: 60,),
          ),onTap: (){},
        ),
        SizedBox(height: 10,),
        Text("Shakil",style: TextStyle(fontWeight: FontWeight.bold),),
        Divider(),
        SizedBox(height: 20,),
        Text("Account Information",style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height: 20,),
        Row(children: [
          Icon(Icons.mail),
          SizedBox(width: 10,),
          Text("email"),

        ],),
        Row(
          children: [
            Icon(Icons.call),
            SizedBox(width: 10,),
            Text("242144"),
          ],),
        SizedBox(height: 20,),
        Divider(),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(child: CircleAvatar(backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXjEvvLvYr01bE7eQ7QaFsEDEMd3eNzeBH3w&usqp=CAU"),),onTap: (){},),
            InkWell(child: CircleAvatar(backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ92XZSrDH5a67gC2b5cmAbVsU8A3LBR_oOfA&usqp=CAU"),),onTap: (){},),
            InkWell(child: CircleAvatar(backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN03QTVJlTZKNC7Cpq94Z4kjeI-CO28Iv4mw&usqp=CAU"),),onTap: (){},)

          ],)


      ],);
  }
}
