import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrentCourse extends StatefulWidget {
  const CurrentCourse({super.key});

  @override
  State<CurrentCourse> createState() => _CurrentCourseState();
}

class _CurrentCourseState extends State<CurrentCourse> {
  // Track selected box
  int selectedBox = 1;

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
                          "Box 1",
                          style: TextStyle(
                            color: selectedBox == 1 ? Colors.white : Colors.black,
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
                            color: selectedBox == 2 ? Colors.white : Colors.black,
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

              // Scrollable list based on selected box
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: selectedBox == 1 ? 5 : 3, // Example: 5 items for Box 1, 3 items for Box 2
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      width: double.infinity,
                      height: 127,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Center(
                        child: Text(
                          selectedBox == 1
                              ? 'Box 1.${index + 1}' // Box 1.1, Box 1.2, Box 1.3...
                              : 'Box 2.${index + 1}', // Box 2.1, Box 2.2, Box 2.3...
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
