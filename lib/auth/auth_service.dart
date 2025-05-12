import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  


  // Register new user
  Future<User?> createUserWithEmailAndPassword(
    String email, 
    String password, 
    BuildContext context // Accept context as a parameter
  ) async {
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showErrorDialog(context, 'The email is already in use.');
      } else {
        _showErrorDialog(context, 'Registration failed: ${e.message}');
      }
    } catch (e) {
      log("Unexpected error: $e");
    }
    return null; // Return null if registration failed
  }

  // Login existing user
  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException during login: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      log("Unexpected error during login: $e");
      rethrow;
    }
  }

  // Logout user
  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Error during sign out: $e");
      rethrow;
    }
  }
  
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
