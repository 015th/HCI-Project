import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

// Validation function for login
  void _LoginPressed() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both email and password'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // User creation logic
      final user = await _auth.loginUserWithEmailAndPassword(
        _emailController.text, 
        _passwordController.text,
      );
      if (user != null) {
        log("User Login Successfully");
        
        // Proceed to the next page if the fields are filled
        Navigator.pushReplacementNamed(context, "/question");  // Navigate to login screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'extend',
          style: TextStyle(
            fontSize: 25,
            color: Colors.cyan,
            shadows: [
              Shadow(
                offset: Offset(0, 4),
                blurRadius: 4,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Please enter your details',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // email FIELD
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Email',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Enter Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // PASSWORD FIELD
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Password',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // REMEMBER ME & FORGOT PASSWORD
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text('Remember me'),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            
            // LOGIN BUTTON
            ElevatedButton(
              onPressed: _LoginPressed, // Validate before navigating
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 10),

            // NAVIGATE TO REGISTER
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
