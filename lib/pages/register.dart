import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

final _auth = AuthService();


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isChecked = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Function to show Date Picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dateOfBirthController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "extend",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Email Field with Validation
                _buildTextField("Email Address", _emailController,
                    TextInputType.emailAddress, validator: (value) {
                  if (value!.isEmpty) return "Please enter your email";
                  if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                }),

                // Username Field
                _buildTextField(
                    "Username", _usernameController, TextInputType.text),

                // Full Name Field
                _buildTextField(
                    "Full Name", _fullNameController, TextInputType.text),

                // Date of Birth with Picker
                _buildDateOfBirthField(),

                // Password Field with Validation
                _buildPasswordField("Password", _passwordController, false),

                // Confirm Password Field with Validation
                _buildPasswordField(
                    "Confirm Password", _confirmPasswordController, true),

                const SizedBox(height: 10),

                // Privacy Policy Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isChecked = newValue!;
                        });
                      },
                    ),
                    const Expanded(
                      child:
                          Text("I have read and agree to the privacy policy"),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Create Account Button
                SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _onCreateAccountPressed(context),
                  child: const Text("Create Account"),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // General Text Field Builder
  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: validator ??
            (value) => value!.isEmpty
                ? "Please enter $label"
                : null, // Default validator
      ),
    );
  }

  // Date of Birth Field with Calendar Picker
  Widget _buildDateOfBirthField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: _dateOfBirthController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Date of Birth",
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ),
        validator: (value) =>
            value!.isEmpty ? "Please select your date of birth" : null,
      ),
    );
  }

  // Password Field with Visibility Toggle and Validation
  Widget _buildPasswordField(
      String label, TextEditingController controller, bool isConfirm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText:
            isConfirm ? !_isConfirmPasswordVisible : !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              isConfirm
                  ? (_isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off)
                  : (_isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
            ),
            onPressed: () {
              setState(() {
                if (isConfirm) {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                } else {
                  _isPasswordVisible = !_isPasswordVisible;
                }
              });
            },
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) return "Please enter $label";
          if (!isConfirm && value.length < 6) {
            return "Password must be at least 6 characters";
          }
          if (isConfirm && value != _passwordController.text) {
            return "Passwords do not match";
          }
          return null;
        },
      ),
    );
  }

  void _onCreateAccountPressed(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to the privacy policy")),
      );
    } else {
      // User creation logic
      final user = await _auth.createUserWithEmailAndPassword(
        _emailController.text, 
        _passwordController.text,
      );
      if (user != null) {
        log("User Created Successfully");
        Navigator.pushReplacementNamed(context, "/login");  // Navigate to login screen
      }
    }
  }
}

}
