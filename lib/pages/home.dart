import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/courseService.dart';
import 'package:flutter_application_1/pages/course_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference fetchData = FirebaseFirestore.instance.collection('testcourse');
  final user = FirebaseAuth.instance.currentUser;
  final CourseService _courseService = CourseService(); // Instance of CourseService



  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('extend'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: StreamBuilder(
        stream: fetchData.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                final courseId = documentSnapshot.id;

                // Check if the course is already saved by the user
                return FutureBuilder<bool>(
                  future: isCourseSaved(courseId),
                  builder: (context, snapshot) {
                    bool isSaved = snapshot.data ?? false;

                    return Material(
                      child: ListTile(
                        title: Text(documentSnapshot['title']),
                        subtitle: Text(documentSnapshot['description'],),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseDetailPage(courseData: documentSnapshot),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,  // Change icon based on saved state
                            color: isSaved ? Colors.red : null,  // Red color for saved course
                          ),
                          onPressed: () {
                            if (isSaved) {
                              _courseService.showDeleteDialog(context, () {
                              _courseService.removeCourseFromUser(courseId, context);
                            });
                            } else {
                              _courseService.saveCourseToUser(courseId, documentSnapshot.data() as Map<String, dynamic>, context);
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // Check if the course is saved by the user
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
