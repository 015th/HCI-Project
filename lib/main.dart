import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/mainScreen.dart'; // <--- Import your MainScreen
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/bottomNav.dart';
import 'package:flutter_application_1/pages/question.dart';
import 'package:flutter_application_1/pages/course_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/pages/settings.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Nunito Sans'),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const NavigatorPage(),
        '/question': (context) => const QuestionScreen(),
        '/settings': (context) => const SettingsPage(),
        // Add other routes as needed
      },
    );
  }
}
