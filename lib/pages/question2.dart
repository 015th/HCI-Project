import 'package:flutter/material.dart';
import 'question3.dart';

class SecondQuestionScreen extends StatefulWidget {
  final List<String> selectedSkills;

  const SecondQuestionScreen({super.key, required this.selectedSkills});

  @override
  _SecondQuestionScreenState createState() => _SecondQuestionScreenState();
}

class _SecondQuestionScreenState extends State<SecondQuestionScreen> {
  String? selectedAnswer;

  void _nextQuestion() {
    if (selectedAnswer != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThirdQuestionScreen(
              selectedSkills: widget.selectedSkills,
              experienceLevel: selectedAnswer!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Question 2")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("What is your experience level?",
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Column(
              children: ["Beginner", "Intermediate", "Advanced"].map((level) {
                return RadioListTile<String>(
                  title: Text(level),
                  value: level,
                  groupValue: selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      selectedAnswer = value;
                    });
                  },
                );
              }).toList(),
            ),
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
