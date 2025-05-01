import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'course_detail.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic>? userPreferences;

  const HomePage({super.key, this.userPreferences});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference fetchData = FirebaseFirestore.instance.collection('testcourse');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Light background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'extend',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: fetchData.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasError) {
            return const Center(child: Text('Error fetching data.'));
          }
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (streamSnapshot.hasData) {
            final allCourses = streamSnapshot.data!.docs;

            // Apply filtering logic
            final subjectCourses = widget.userPreferences == null
                ? <QueryDocumentSnapshot>[]
                : allCourses.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final selectedSubjects = widget.userPreferences!['subjects'] ?? [];
                    return selectedSubjects.contains(data['subject']);
                  }).toList();

            final difficultyCourses = widget.userPreferences == null
                ? <QueryDocumentSnapshot>[]
                : allCourses.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return data['difficulty'] == widget.userPreferences!['difficulty'];
                  }).toList();

            final durationCourses = widget.userPreferences == null
                ? <QueryDocumentSnapshot>[]
                : allCourses.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    int totalDuration = 0;
                    for (var lesson in data['lessons'] ?? []) {
                      totalDuration += int.parse(lesson['duration'].split(' ')[0]);
                    }

                    final durationPreference = widget.userPreferences!['duration'];
                    return (durationPreference == "<60 mins" && totalDuration < 60) ||
                        (durationPreference == "61-120 mins" && totalDuration >= 61 && totalDuration <= 120) ||
                        (durationPreference == ">120 mins" && totalDuration > 120);
                  }).toList();

            final randomCourses = List<QueryDocumentSnapshot>.from(allCourses)..shuffle();

            // Build the current layout
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                if (subjectCourses.isNotEmpty)
                  _buildSection('Subject Based on Your Preference', subjectCourses),
                if (difficultyCourses.isNotEmpty)
                  _buildSection('Difficulty Based on Your Preferences', difficultyCourses),
                if (durationCourses.isNotEmpty)
                  _buildSection('Duration Based on Your Preferences', durationCourses),
                _buildSection('Check Other Courses', randomCourses.take(5).toList()),
              ],
            );
          }
          return const Center(child: Text('No courses available.'));
        },
      ),
    );
  }

  // Function to build a section
  Widget _buildSection(String title, List<QueryDocumentSnapshot> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200, // Adjust height for the horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailPage(courseData: course),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(right: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: Container(
                    width: 150, // Adjust width for each card
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title'] ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          course['difficulty'] ?? 'No Difficulty',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.favorite_border, color: Colors.grey),
                            Text(
                              '${course['lessons']?.length ?? 0} Lessons',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}