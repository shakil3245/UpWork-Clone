
import 'package:flutter/material.dart';
import 'package:upworkclone/ui/pages/AddJobsScreen.dart';
import 'package:upworkclone/ui/pages/HomeScreen.dart';
import 'package:upworkclone/ui/pages/LogOutScreen.dart';
import 'package:upworkclone/ui/pages/ProfileScreen.dart';
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  final _Pages =[HomeScreen(),AddJobs(),ProfileScreen(),LogOut()];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        currentIndex: _currentIndex,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF091fce),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.add),label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.logout),label: "Logout"),

        ],
        onTap: (index){
          setState(() {
            _currentIndex=index;
          });
        },
      ),
      body: _Pages[_currentIndex],
    );
  }
}
