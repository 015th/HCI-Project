import 'package:flutter/material.dart';

class CurrentCourse extends StatelessWidget {
  const CurrentCourse({super.key});

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
                  offset: Offset(0, 4),
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
                offset: Offset(0, 4),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.25),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align items to the top
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              SizedBox(height: 16.0), // Space from top
              Row(
                mainAxisSize: MainAxisSize.min, // Wrap content
                children: [ // Wrapped widgets inside children: []
                  Container(
                    width: 138,
                    height: 41,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(27),
                    ),
                    child: Center(
                      child: Text(
                        "Box 1",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Space between Box 1 and Box 2
                 Container(
                    width: 138,
                    height: 41,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(27),
                    ),
                    child: Center(
                      child: Text(
                        "Box 2",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0), // Space from Box 2 to Box 3
              Container(
                    width: 295,
                    height: 127,
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Center(
                      child: Text(
                        "Course 1",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    ); // Scaffold
  }
}
