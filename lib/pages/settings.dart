import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user;
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  Future<bool> _reauthenticate(String currentPassword) async {
    try {
      final cred = EmailAuthProvider.credential(
          email: user!.email!, password: currentPassword);
      await user!.reauthenticateWithCredential(cred);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _changePassword() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    bool reauthenticated = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!reauthenticated) ...[
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Current Password'),
                ),
              ] else ...[
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!reauthenticated) {
                  final success = await _reauthenticate(currentPasswordController.text.trim());
                  if (success) {
                    setStateDialog(() {
                      reauthenticated = true;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Current password is incorrect')),
                    );
                  }
                } else {
                  try {
                    await user!.updatePassword(newPasswordController.text.trim());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password updated')),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: Text(reauthenticated ? 'Update' : 'Verify'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeUsername() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Username'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'New Username'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await user!.updateDisplayName(controller.text.trim());
                await user!.reload();
                setState(() {
                  user = FirebaseAuth.instance.currentUser;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Username updated')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _changeEmail() async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'New Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final cred = EmailAuthProvider.credential(
                    email: user!.email!, password: passwordController.text.trim());
                await user!.reauthenticateWithCredential(cred);
                await user!.updateEmail(emailController.text.trim());
                await user!.reload();
                setState(() {
                  user = FirebaseAuth.instance.currentUser;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email updated')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800]),
        textAlign: TextAlign.left,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Account'),
            ElevatedButton.icon(
              onPressed: _changeUsername,
              icon: const Icon(Icons.edit),
              label: const Text('Change Username'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _changeEmail,
              icon: const Icon(Icons.email),
              label: const Text('Change Email'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _changePassword,
              icon: const Icon(Icons.lock_reset),
              label: const Text('Change Password'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                alignment: Alignment.centerLeft,
              ),
            ),
            _buildSectionTitle('Preferences'),
            SwitchListTile(
              title: const Text('Notifications'),
              value: notificationsEnabled,
              onChanged: (val) {
                setState(() {
                  notificationsEnabled = val;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: darkModeEnabled,
              onChanged: (val) {
                setState(() {
                  darkModeEnabled = val;
                });
                // TODO: Implement actual dark mode toggle
              },
            ),
            _buildSectionTitle('About'),
            ListTile(
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
              onTap: () {
                // Optionally show more info or licenses
              },
            ),
            ListTile(
              title: const Text('Terms of Service'),
              onTap: () {
                // Navigate to terms page or show dialog
              },
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              onTap: () {
                // Navigate to privacy page or show dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}
