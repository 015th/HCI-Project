import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/currentCourse.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/savedCourse.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int myIndex = 0;

  // List of Screens
  List<Widget> screens = [
    const HomePage(),
    const CurrentCourse(),
    const Bookmark(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[myIndex], 
      
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        backgroundColor: Colors.black, // Set background color to black
        selectedItemColor: Colors.cyan, // Active icon & text color
        unselectedItemColor: Colors.grey, // Inactive icon & text color
        currentIndex: myIndex,  // Set initial selected index
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    ); // Scaffold
  }
}
