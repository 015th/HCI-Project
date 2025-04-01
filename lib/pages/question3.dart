import 'package:flutter/material.dart';
import 'home.dart'; 
import 'package:flutter_application_1/bottomNav.dart';

class ThirdQuestionScreen extends StatefulWidget {
  final List<String> selectedSkills;
  final String experienceLevel;

  ThirdQuestionScreen({required this.selectedSkills, required this.experienceLevel});

  @override
  _ThirdQuestionScreenState createState() => _ThirdQuestionScreenState();
}

class _ThirdQuestionScreenState extends State<ThirdQuestionScreen> {
  String? selectedGoal;

  void _finishQuestionnaire() {
    if (selectedGoal != null) {
      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigatorPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Question 3")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("What is your learning goal?", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Column(
              children: ["Career Growth", "Personal Development", "Hobby"].map((goal) {
                return RadioListTile<String>(
                  title: Text(goal),
                  value: goal,
                  groupValue: selectedGoal,
                  onChanged: (value) {
                    setState(() {
                      selectedGoal = value;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _finishQuestionnaire,
              child: Text("Finish"),
            ),
          ],
        ),
      ),
    );
  }
}
