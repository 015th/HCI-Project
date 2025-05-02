import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'course_detail.dart';
import 'all_courses_page.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic>? userPreferences;

  const HomePage({super.key, this.userPreferences});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference fetchData = FirebaseFirestore.instance.collection('testcourse');
  final Set<String> _favoritedCourses = {}; // Track favorited courses by their IDs
  final TextEditingController _searchController = TextEditingController(); // Controller for the search bar
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier(''); // Notifier for the search query
  String _selectedSubject = ''; // Currently selected subject for filtering

  @override
  void dispose() {
    _searchController.dispose();
    _searchQueryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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

          // Extract unique subjects
          final subjects = allCourses
              .map((doc) => (doc.data() as Map<String, dynamic>)['subject'] as String)
              .toSet()
              .toList();

          return Column(
            children: [
              // Top navigation part with white background
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'extend',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance for the back button
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search Courses',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              _searchQueryNotifier.value = value; // Update the search query
                            },
                          ),
                        ),
                        ValueListenableBuilder<String>(
                          valueListenable: _searchQueryNotifier,
                          builder: (context, searchQuery, child) {
                            if (searchQuery.isNotEmpty) {
                              return GestureDetector(
                                onTap: () {
                                  _searchQueryNotifier.value = '';
                                  _searchController.clear(); // Clear the search bar
                                },
                                child: const Icon(Icons.close, color: Colors.grey),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Subject filter section
              if (subjects.isNotEmpty)
                _buildSubjectsSection('Filter by Subject', subjects, allCourses),

              // Main scrollable content
              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: _searchQueryNotifier,
                  builder: (context, searchQuery, child) {
                    // Apply filtering logic with search query and selected subject
                    final filteredCourses = allCourses.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final title = data['title']?.toString().toLowerCase() ?? '';
                      final subject = data['subject']?.toString() ?? '';
                      final matchesSearch = title.contains(searchQuery.toLowerCase());
                      final matchesSubject = _selectedSubject.isEmpty || subject == _selectedSubject;
                      return matchesSearch && matchesSubject;
                    }).toList();

                    final subjectCourses = widget.userPreferences == null
                        ? <QueryDocumentSnapshot>[]
                        : filteredCourses.where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final selectedSubjects = widget.userPreferences!['subjects'] ?? [];
                            return selectedSubjects.contains(data['subject']);
                          }).toList();

                    final difficultyCourses = widget.userPreferences == null
                        ? <QueryDocumentSnapshot>[]
                        : filteredCourses.where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return data['difficulty'] == widget.userPreferences!['difficulty'];
                          }).toList();

                    final durationCourses = widget.userPreferences == null
                        ? <QueryDocumentSnapshot>[]
                        : filteredCourses.where((doc) {
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

                    // Filter remaining courses for "Check Other Courses"
                    final shownCourses = {...subjectCourses, ...difficultyCourses, ...durationCourses};
                    final remainingCourses = filteredCourses.where((course) => !shownCourses.contains(course)).toList();

                    // Wrap the Column in a SingleChildScrollView to prevent overflow
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Course sections
                          if (subjectCourses.isNotEmpty)
                            _buildCoursesSection('Subject Based on Your Preference', subjectCourses),

                          if (difficultyCourses.isNotEmpty)
                            _buildCoursesSection('Difficulty Based on Your Preference', difficultyCourses),

                          if (durationCourses.isNotEmpty)
                            _buildCoursesSection('Duration Based on Your Preference', durationCourses),

                          // Random courses section
                          if (remainingCourses.isNotEmpty)
                            _buildCoursesSection('Check Other Courses', remainingCourses),

                          // Add bottom padding to prevent content from being hidden behind the navigation bar
                          const SizedBox(height: 70),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: Text('No courses available.'));
      },
    );
  }

  // Build subject section with horizontal scrolling
  Widget _buildSubjectsSection(String title, List<String> subjects, List<QueryDocumentSnapshot> allCourses) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Black color for the title
              ),
            ),
          ),
          SizedBox(
            height: 65, // Height for the horizontal list
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedSubject == subjects[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSubject = isSelected ? '' : subjects[index]; // Toggle subject filter
                    });
                  },
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        subjects[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build courses section with horizontal scrolling
  Widget _buildCoursesSection(String title, List<QueryDocumentSnapshot> courses) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Black color for the title
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllCoursesPage(
                          title: title,
                          courses: courses,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index].data() as Map<String, dynamic>;
                final courseId = courses[index].id; // Use the document ID as a unique identifier
                final lessons = course['lessons'] ?? [];
                int totalDuration = 0;

                // Calculate total duration
                for (var lesson in lessons) {
                  final durationString = lesson['duration'] ?? '0 minutes';
                  final durationInMinutes = int.parse(durationString.split(' ')[0]);
                  totalDuration += durationInMinutes;
                }

                return GestureDetector(
                  onTap: () {
                    // Navigate to course details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailPage(
                          courseData: courses[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade300, width: 0.5),
                      ),
                      color: Colors.grey.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course['title'] ?? 'No Title',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              course['difficulty'] ?? 'No Difficulty',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalDuration mins',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_favoritedCourses.contains(courseId)) {
                                        _favoritedCourses.remove(courseId); // Remove from favorites
                                      } else {
                                        _favoritedCourses.add(courseId); // Add to favorites
                                      }
                                    });
                                  },
                                  child: Icon(
                                    _favoritedCourses.contains(courseId)
                                        ? Icons.favorite // Red heart
                                        : Icons.favorite_border, // Grey heart
                                    color: _favoritedCourses.contains(courseId)
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 16,
                                  ),
                                ),
                                Text(
                                  '${lessons.length} Lessons',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}