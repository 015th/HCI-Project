import 'package:flutter/material.dart';
import 'question2.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<String> selectedSubjects = [];

  void _toggleSelection(String subject) {
    setState(() {
      if (selectedSubjects.contains(subject)) {
        selectedSubjects.remove(subject);
      } else {
        selectedSubjects.add(subject);
      }
    });
  }

  void _nextQuestion() {
    if (selectedSubjects.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondQuestionScreen(selectedSubjects: selectedSubjects),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one subject.')),
      );
    }
  }

  void _skipQuestion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondQuestionScreen(selectedSubjects: []),
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  List<String> subjects = [
    "Computer Science", "Mathematics", "Psychology", "Economics", "Biology",
    "Artificial Intelligence", "Data Science", "Cybersecurity", "Cloud Computing",
    "Blockchain", "Machine Learning", "DevOps", "Game Development", "Robotics",
    "Quantum Computing", "Natural Language Processing"
  ];

   return PopScope(
    canPop: false,
    child: Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
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
                          "What subjects are you interested in?",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ...subjects.map((subject) {
                          return GestureDetector(
                            onTap: () => _toggleSelection(subject),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: selectedSubjects.contains(subject)
                                    ? Colors.cyan.withOpacity(0.2)
                                    : Colors.white,
                                border: Border.all(
                                  color: selectedSubjects.contains(subject)
                                      ? Colors.cyan
                                      : Colors.grey,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                child: Center(
                                  child: Text(
                                    subject,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedSubjects.contains(subject)
                                          ? Colors.cyan
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 30),
                              ),
                              child: const Text(
                                "Skip",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 3, 3, 3),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: _nextQuestion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 30),
                              ),
                              child: const Text("Next"),
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
    ),
  );
}
}