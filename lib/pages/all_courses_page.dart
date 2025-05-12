import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'course_detail.dart';
import 'package:flutter_application_1/courseService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AllCoursesPage extends StatelessWidget {
  
  final String title;
  final List<QueryDocumentSnapshot> courses;
  final CourseService _courseService = CourseService();
  final User? user = FirebaseAuth.instance.currentUser;

  AllCoursesPage({super.key, required this.title, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
        final course = courses[index].data() as Map<String, dynamic>;
        final courseId = courses[index].id;
          return FutureBuilder<bool>(
            future: isCourseSaved(courseId),
            builder: (context, snapshot) {
            bool isSaved = snapshot.data ?? false;

              return GestureDetector(
                onTap: () {
                  // Navigate to course details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailPage(courseData: courses[index]),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey.shade300, width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title'] ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course['difficulty'] ?? 'N/A',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${course['lessons']?.length ?? 0} Lessons',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            IconButton(
                              icon: Icon(
                                isSaved ? Icons.favorite : Icons.favorite_border,
                                color: isSaved ? Colors.red : null,
                              ),
                              onPressed: () {
                                if (isSaved) {
                                  // Show delete dialog
                                  _courseService.showDeleteDialog(context, () {
                                  _courseService.removeCourseFromUser(courseId, context);
                                  });
                                } else {
                                  // Save course to user
                                  _courseService.saveCourseToUser(courseId, course, context);
                                }
                              },
                            ),
                          ],
                      ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

    Future<bool> isCourseSaved(String courseId) async {
    if (user == null) {
      return false;  // User is not logged in
    }
    
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid) // Null check on user before accessing uid
        .collection('saved_courses')
        .doc(courseId)
        .get();

    return doc.exists;
  }

}