import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/courseService.dart';
import 'package:flutter_application_1/pages/course_details.dart';

class CurrentCourse extends StatefulWidget {
  const CurrentCourse({super.key});

  @override
  State<CurrentCourse> createState() => _CurrentCourseState();

}

class _CurrentCourseState extends State<CurrentCourse> {
  // Track selected box
  int selectedBox = 1;

  final user = FirebaseAuth.instance.currentUser;
  final CourseService _courseService = CourseService(); // Instance of CourseService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            'extend',
            style: TextStyle(
              fontSize: 25,
              color: Colors.cyan,
              shadows: [
                Shadow(
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.25),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBox = 1;
                      });
                    },
                    child: Container(
                      width: 138,
                      height: 41,
                      decoration: BoxDecoration(
                        color: selectedBox == 1 ? Colors.cyan : Colors.white,
                        borderRadius: BorderRadius.circular(27),
                        border: Border.all(color: Colors.cyan),
                      ),
                      child: Center(
                        child: Text(
                          "Ongoing",
                          style: TextStyle(
                            color:
                                selectedBox == 1 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBox = 2;
                      });
                    },
                    child: Container(
                      width: 138,
                      height: 41,
                      decoration: BoxDecoration(
                        color: selectedBox == 2 ? Colors.cyan : Colors.white,
                        borderRadius: BorderRadius.circular(27),
                        border: Border.all(color: Colors.cyan),
                      ),
                      child: Center(
                        child: Text(
                          "Completed",
                          style: TextStyle(
                            color:
                                selectedBox == 2 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Conditional rendering using spread operator
              ...[
                if (selectedBox == 1)
                 StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                         .collection('users')
                         .doc(user!.uid)
                         .collection('enrolled_courses')
                         .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      final docs = snapshot.data?.docs ?? [];

                      if (docs.isEmpty) {
                        return const Text("No ongoing courses yet.");
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final course = docs[index].data() as Map<String, dynamic>;
                          final title = course['title'] ?? 'No title';
                          final description = course['description'] ?? 'No description';

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseDetailPage(courseData: docs[index]),
                                ),
                              );
                            },
                           child:Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                           .collection('enrolled_courses')
                                           .doc(docs[index].id)
                                           .delete();
                                       });
                                      },
                                     ),
                                    ],
                                 ),
                                const SizedBox(height: 8),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          );
                        },
                      );

                                          },
                  )

                else
                  const Text(
                    'Completed courses ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),


              ],
            ],
          ),
        ),
      ),
    );
  }
}
