import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CourseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save course to bookmarks
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

  // Enroll course and update weekly activity time
  Future<void> enrollCourseToUser(String courseId, Map<String, dynamic> courseData, BuildContext context) async {
    final user = _auth.currentUser;

    if (user != null) {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Add course to enrolled_courses
      await userDocRef.collection('enrolled_courses').doc(courseId).set(courseData);

      // Fetch current weeklyActivity or set default
      final userSnapshot = await userDocRef.get();

      if (userSnapshot.exists) {
        final data = userSnapshot.data()!;
        int currentWeeklyActivity = (data['weeklyActivity'] ?? 0) as int;

        // If 0, set to 45; else add 45 minutes
        final updatedWeeklyActivity = currentWeeklyActivity == 0 ? 45 : currentWeeklyActivity + 45;

        await userDocRef.update({
          'weeklyActivity': updatedWeeklyActivity,
        });
      } else {
        // Create user doc with weeklyActivity if not exists (rare case)
        await userDocRef.set({'weeklyActivity': 45}, SetOptions(merge: true));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course enrolled! Weekly activity updated.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to enroll in courses.')),
      );
    }
  }

  // Remove course from bookmarks
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

  // Show confirmation dialog for deletion
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
                onDelete(); // Execute delete callback
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
