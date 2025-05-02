import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/bottomNav.dart';
import 'package:flutter_application_1/pages/question.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Clear the collection and upload JSON data to Firestore
  await clearTestCourseCollection();
  await uploadCoursesToFirestore();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Nunito Sans'),
      initialRoute: '/question', // Start with the question screen
      routes: {
        '/login': (context) => const LoginPage(),
        '/question': (context) => const QuestionScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const NavigatorPage(), // Use NavigatorPage for home navigation
      },
    );
  }
}

// Function to upload JSON data to Firestore
Future<void> uploadCoursesToFirestore() async {
  try {
    // Load the JSON file
    String jsonString = await rootBundle.loadString('assets/full_courses_7.json');
    Map<String, dynamic> jsonData = Map<String, dynamic>.from(await json.decode(jsonString));

    // Reference to the Firestore collection
    CollectionReference coursesCollection = FirebaseFirestore.instance.collection('testcourse');

    // Debug: Log total courses in JSON
    debugPrint('Total courses in JSON: ${jsonData['courses'].length}');
    int uploadedCount = 0;

    // Iterate through the courses and upload them
    for (var course in jsonData['courses']) {
      await coursesCollection.doc(course['course_id']).set({
        'title': course['title'],
        'subject': course['subject'],
        'difficulty': course['difficulty'],
        'description': course['description'],
        'lessons': course['lessons'],
      });
      uploadedCount++;
      debugPrint('Uploaded course: ${course['title']}');
    }

    debugPrint('Total courses uploaded: $uploadedCount');
  } catch (e) {
    debugPrint('Error uploading courses: $e');
  }
}

// Function to clear the testcourse collection
Future<void> clearTestCourseCollection() async {
  try {
    final collection = FirebaseFirestore.instance.collection('testcourse');
    final snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    debugPrint('Cleared testcourse collection.');
  } catch (e) {
    debugPrint('Error clearing collection: $e');
  }
}
