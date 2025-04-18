import 'package:flutter/material.dart';
import 'home.dart'; // Import the home screen
import 'question2.dart'; // Import the second question screen

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<String> selectedSkills = [];

  void _toggleSelection(String skill) {
    setState(() {
      if (selectedSkills.contains(skill)) {
        selectedSkills.remove(skill);
      } else {
        selectedSkills.add(skill);
      }
    });
  }

  void _nextQuestion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SecondQuestionScreen(selectedSkills: selectedSkills),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> skills = [
      "Risk Management",
      "Access Control",
      "Web Development",
      "Artificial Intelligence (AI)",
      "Machine Learning"
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Question 1")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("What skills would you like to learn?",
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ...skills.map((skill) {
              bool isSelected = selectedSkills.contains(skill);
              return GestureDetector(
                onTap: () => _toggleSelection(skill),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(12),
                  width: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: isSelected ? Colors.cyan : Colors.black),
                    borderRadius: BorderRadius.circular(30),
                    color: isSelected
                        ? Colors.cyan.withOpacity(0.2)
                        : Colors.transparent,
                  ),
                  child: Center(
                      child: Text(skill, style: const TextStyle(fontSize: 16))),
                ),
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextQuestion,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
