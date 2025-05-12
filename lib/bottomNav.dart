import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/currentCourse.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/savedCourse.dart';

class NavigatorPage extends StatefulWidget {
  final Map<String, dynamic>? userPreferences;

  const NavigatorPage({super.key, this.userPreferences});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int myIndex = 0;

  late List<Widget> screens;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve arguments passed to /home
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Initialize screens with userPreferences
    screens = [
      HomePage(userPreferences: args ?? widget.userPreferences), // Pass userPreferences to HomePage
      const CurrentCourse(),
      const Bookmark(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: screens[myIndex], // Show the selected screen
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: myIndex,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Enrolled',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}