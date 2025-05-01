import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/courseService.dart';
import 'package:flutter_application_1/pages/course_details.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  final user = FirebaseAuth.instance.currentUser;
  final _courseService = CourseService(); // Instance of CourseService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 30.0),
          child: Text(
            'extend',
            style: TextStyle(
              fontSize: 25,
              color: Colors.cyan,
              shadows: [
                Shadow(
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 400,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.25),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                "Bookmark",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: user == null
                    ? const Center(child: Text("Please log in to see bookmarks."))
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .collection('saved_courses')
                            .snapshots(),


                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final docs = snapshot.data!.docs;
                            if (docs.isEmpty) {
                              return const Center(child: Text("No saved courses yet."));
                            }
                            return GridView.builder(
                              padding: const EdgeInsets.all(10),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.75, // Taller cards
                              ),
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                final course = docs[index].data() as Map<String, dynamic>;
                                final documentSnapshot = docs[index];
                                String description = course['description'] ?? 'No Description';
                                String title = course['title'] ?? 'No Title';
                                String subject = course['subject'] ?? 'No Subject';

                                return InkWell(
                                   onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CourseDetailPage(courseData: documentSnapshot),
                                      ),
                                    );
                                  },
                                  child:Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 2),
                                        blurRadius: 4,
                                        color: Colors.black.withOpacity(0.15),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      // Blue header with description
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        height: 120,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF3ABEF9),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          description,
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        
                                      ),

                                      // White section with title, lesson count and enroll button
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFD9D9D9),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Title with delete button
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    title,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                   
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  onPressed: () {
                                                    _courseService.showDeleteDialog(context, () async {
                                                      await FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(user!.uid)
                                                          .collection('saved_courses')
                                                          .doc(documentSnapshot.id)
                                                          .delete();
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            
                                            // Lesson count
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4, bottom: 8),
                                              child: Text(
                                                subject,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ),
                                            
                                            // Enroll button
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Pass the courseId and course data to the enroll method
                                                _courseService.enrollCourseToUser(
                                                  documentSnapshot.id,  // The course's unique ID from Firestore
                                                  documentSnapshot.data() as Map<String, dynamic>,  // The course data (fields like title, description)
                                                  context ); // The context for showing the SnackBar
                                                  },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:  Colors.transparent,
                                                  foregroundColor: Colors.cyan,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                side: BorderSide(
                                                    color: Color(0xFF00ADB5), // Border color
                                                    width: 2, // Border width
                                                  ),
                                                                                                  
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                ),
                                                child: const Text("Enroll",
                                                 style: TextStyle(
                                                  fontSize: 14,
                                                ),),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                );
                              },
                            );
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}