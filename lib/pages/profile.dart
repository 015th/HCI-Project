  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter_application_1/bottomNav.dart';


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
    final List<Map<String, dynamic>> achievements = [];

    int coursesCount = 0; // Add coursesCount state

    @override
    void initState() {
      super.initState();
      user = FirebaseAuth.instance.currentUser;
      _loadUserData();
      _listenToCoursesCount(); // Add listener for courses count
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

    void _listenToCoursesCount() {
      if (user == null) return;
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('enrolledCourses')
          .snapshots()
          .listen((snapshot) {
        setState(() {
          coursesCount = snapshot.docs.length;
        });
      });
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

      // Real-time data for weekly activity bars and stats
      final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final double weeklyHours = weeklyActivityMinutes / 60;
      final int coursesCount = 0; // set to zero for new accounts, update dynamically when user enrolls courses

      // Fetch real-time weekly activity heights from Firestore or local state
      List<double> activityHeights = List.filled(7, 0);
      // Example: Fetch daily activity minutes for each day of the week from Firestore

      return PopScope(
        canPop: false,
      child: Scaffold(
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
          automaticallyImplyLeading: false, 
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                 child: SingleChildScrollView(
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

                      // Achievements Cards Horizontal List or "Start Learning Now!" button if no achievements
                      achievements.isEmpty
                          ? Column(
                              children: [
                                const SizedBox(height: 12),
                                Text(
                                  'No achievements yet',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigate to explore tab using bottomNav.dart index
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NavigatorPage(),
                                      ),
                                    );
                                  },
                                  child: const Text('Start Learning Now!'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    textStyle: GoogleFonts.poppins(
                                        fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
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
                                // Removed percentage change arrow and text
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
                            // Courses count only, real-time, no avg grade
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Open Settings Button
                    MouseRegion(
                    cursor: SystemMouseCursors.click, 
                      child: GestureDetector(
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
                  ),
                                           
                      // Sign Out Button
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          
                          padding: const EdgeInsets.all(16.0),  
                          child: ElevatedButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut().then((_) {
                              Navigator.pushNamedAndRemoveUntil(
                                context, 
                                '/login', 
                                (Route<dynamic> route) => false,
                              );
                            });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                              foregroundColor:  Colors.black,// Text color
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              textStyle: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            child: const Text('Sign Out'),
                          ),
                        ),
                      ),
                    ],
                  ),
                 ), // SingleChildScrollView
                ),
            ),     
           ),
      );
    }
  }
