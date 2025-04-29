// course_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CourseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to save the course to Firestore (saved_courses)
  Future<void> saveCourseToUser(String courseId, Map<String, dynamic> courseData, BuildContext context) async {
    final user = _auth.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_courses')
          .doc(courseId)
          .set(courseData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course saved to bookmarks!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save courses.')),
      );
    }
  }

  // Function to enroll the course (enrolled_courses)
  Future<void> enrollCourseToUser(String courseId, Map<String, dynamic> courseData, BuildContext context) async {
    final user = _auth.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('enrolled_courses')
          .doc(courseId)
          .set(courseData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course enrolled!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to enroll in courses.')),
      );
    }
  }

  // Function to remove the course from Firestore
  Future<void> removeCourseFromUser(String courseId, BuildContext context) async {
    final user = _auth.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_courses')
          .doc(courseId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course removed from bookmarks!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to remove courses.')),
      );
    }
  }

  Future<void> showDeleteDialog(BuildContext context, VoidCallback onDelete) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Course'),
        content: const Text('Are you sure you want to delete this course?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              onDelete(); // Call the passed-in function
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}
