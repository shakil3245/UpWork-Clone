
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  final String name;
  VoidCallback onPress;
  Btn({
    super.key, required this.name, required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor:  Color(0xFF091fce)),
          onPressed: onPress,
          child: Text(
            name,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}