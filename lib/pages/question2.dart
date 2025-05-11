import 'package:flutter/material.dart';
import 'question3.dart';

class SecondQuestionScreen extends StatefulWidget {
  final List<String> selectedSubjects;

  const SecondQuestionScreen({super.key, required this.selectedSubjects});

  @override
  _SecondQuestionScreenState createState() => _SecondQuestionScreenState();
}

class _SecondQuestionScreenState extends State<SecondQuestionScreen> {
  String? selectedDifficulty;

  void _nextQuestion() {
    if (selectedDifficulty != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThirdQuestionScreen(
            selectedSubjects: widget.selectedSubjects,
            selectedDifficulty: selectedDifficulty!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a difficulty level.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> difficulties = ["Beginner", "Intermediate", "Advanced"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                          "What is your preferred difficulty level?",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ...difficulties.map((difficulty) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDifficulty = difficulty;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: selectedDifficulty == difficulty ? Colors.cyan.withOpacity(0.2) : Colors.white,
                                border: Border.all(
                                  color: selectedDifficulty == difficulty ? Colors.cyan : Colors.grey,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                child: Center(
                                  child: Text(
                                    difficulty,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedDifficulty == difficulty ? Colors.cyan : Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                          ),
                          child: const Text("Next"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F8F8),
    );
  }
}
