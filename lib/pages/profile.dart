import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  int weeklyActivityMinutes = 0;
  bool isLoading = false;

  // Dummy data for achievements - replace with real data if available
  final List<Map<String, dynamic>> achievements = [
    {
      'title': 'Basic Python',
      'course': 'Python Crash Course',
      'date': 'Apr 11, 2023',
      'grade': '96%',
      'color': Colors.orange,
      'icon': Icons.code,
    },
    {
      'title': 'Google',
      'course': 'Google UX Design',
      'date': 'Jun 3, 2022',
      'grade': '98%',
      'color': Colors.blue,
      'icon': Icons.design_services,
    },
    {
      'title': 'AI Badge',
      'course': 'AI Fundamentals',
      'date': 'Jan 15, 2023',
      'grade': '92%',
      'color': Colors.deepPurple,
      'icon': Icons.smart_toy,
    },
  ];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user == null) return;
    setState(() {
      isLoading = true;
    });
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          weeklyActivityMinutes = data['weeklyActivity'] ?? 0;
        });
      }
      await user!.reload();
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      // Handle error if needed
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _changeProfilePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${user!.uid}.jpg');

      // For web and mobile compatibility, upload bytes instead of File
      final bytes = await pickedImage.readAsBytes();
      await storageRef.putData(bytes);

      final downloadUrl = await storageRef.getDownloadURL();
      await user!.updatePhotoURL(downloadUrl);
      await user!.reload();
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading photo: $e')),
      );
    }
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: achievement['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(achievement['icon'], size: 28, color: achievement['color']),
              const SizedBox(width: 8),
              Text(
                achievement['title'],
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            achievement['course'],
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            achievement['date'],
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grade: ${achievement['grade']}',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Implement share functionality here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share feature not implemented')),
                  );
                },
                icon: const Icon(Icons.share, size: 16),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: achievement['color'],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  textStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivityBar(double height, bool isActive) {
    return Container(
      width: 20,
      height: height,
      decoration: BoxDecoration(
        color: isActive ? Colors.blueAccent : Colors.blueAccent.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photo = user?.photoURL ?? 'https://via.placeholder.com/150';
    final displayName = user?.displayName ?? 'User Name';
    final email = user?.email ?? '';

    // Dummy data for weekly activity bars and stats
    final List<double> activityHeights = [60, 80, 40, 100, 70, 90, 50];
    final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final double weeklyHours = weeklyActivityMinutes / 60;
    final double percentageChange = 14; // example percentage change
    final int coursesCount = 15; // example courses count
    final int avgGrade = 83; // example average grade

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F3F7),
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _changeProfilePicture,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(photo),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: GoogleFonts.poppins(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      email,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: Colors.grey[700]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.verified,
                                            size: 16, color: Colors.green),
                                        const SizedBox(width: 4),
                                        Text(
                                          'User Verified',
                                          style: GoogleFonts.poppins(
                                              fontSize: 12, color: Colors.green[800]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // My Achievements Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Achievements',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () {
                            // Implement view all achievements
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('View All not implemented')),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'View All (1)',
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.blueAccent),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blueAccent),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Achievements Cards Horizontal List
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: achievements.length,
                        itemBuilder: (context, index) {
                          return _buildAchievementCard(achievements[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Weekly Activities Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly Activities',
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${weeklyHours.toStringAsFixed(1)} Hours',
                                style: GoogleFonts.poppins(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  Icon(Icons.arrow_upward, color: Colors.green[600], size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$percentageChange% from last week',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Bar chart for weekly activity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(7, (index) {
                              return Column(
                                children: [
                                  _buildWeeklyActivityBar(activityHeights[index], true),
                                  const SizedBox(height: 6),
                                  Text(
                                    weekDays[index],
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              );
                            }),
                          ),
                          const SizedBox(height: 16),

                          // Courses and Avg Grade stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Courses',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.grey[600]),
                                  ),
                                  Text(
                                    '$coursesCount',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Avg Grade',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.grey[600]),
                                  ),
                                  Text(
                                    '$avgGrade%',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Open Settings Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.settings, color: Colors.black87),
                                const SizedBox(width: 12),
                                Text(
                                  'Open Settings',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
