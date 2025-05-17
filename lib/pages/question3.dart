import 'package:flutter/material.dart';
import 'home.dart';

class ThirdQuestionScreen extends StatefulWidget {
  final List<String> selectedSubjects;
  final String selectedDifficulty;

  const ThirdQuestionScreen({
    super.key,
    required this.selectedSubjects,
    required this.selectedDifficulty,
  });

  @override
  _ThirdQuestionScreenState createState() => _ThirdQuestionScreenState();
}

class _ThirdQuestionScreenState extends State<ThirdQuestionScreen> {
  String? selectedDuration;

  void _goToHomePage() {
    if (selectedDuration != null) {
      Navigator.pushReplacementNamed(
        context,
        '/home', // Navigate to the NavigatorPage route
        arguments: {
          'subjects': widget.selectedSubjects,
          'difficulty': widget.selectedDifficulty,
          'duration': selectedDuration,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a duration.')),
      );
    }
  }

  void _skipQuestion() {
    Navigator.pushReplacementNamed(
      context,
     '/home', // Navigate to the NavigatorPage route
      arguments: {
        'subjects': null,
        'difficulty': null,
        'duration': null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> durations = ["<60 mins", "61-120 mins", ">120 mins"];

    return Scaffold(
  
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "extend",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "What is your preferred course duration?",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ...durations.map((duration) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDuration = duration;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: selectedDuration == duration ? Colors.cyan.withOpacity(0.2) : Colors.white,
                                border: Border.all(
                                  color: selectedDuration == duration ? Colors.cyan : Colors.grey,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                child: Center(
                                  child: Text(
                                    duration,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedDuration == duration ? Colors.cyan : Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          ElevatedButton(
                            onPressed: _skipQuestion,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                            ),
                            child: const Text("Skip",
                              style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 3, 3, 3),
                            ),
                            ),
                          ),
                          const SizedBox(width: 20), 

                           ElevatedButton(
                            onPressed: _goToHomePage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                            ),
                            child: const Text("Finish"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
           const SizedBox(height: 20),
        ],
      ),
      backgroundColor: const Color(0xFFF8F8F8),
    );
  }
}
