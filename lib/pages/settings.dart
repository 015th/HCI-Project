import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user;
  // bool notificationsEnabled = true;
  // bool darkModeEnabled = false;

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
    const passwordPattern = r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{7,}$';
    
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
                }  else {
                final newPassword = newPasswordController.text.trim();

                // Validate new password with regex
                if (!RegExp(passwordPattern).hasMatch(newPassword)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Password must be at least 7 characters, include 1 uppercase letter, 1 number, and 1 special character.',
                      ),
                    ),
                  );
                  return; // Stop further execution
                }
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

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'qccangus01@tip.edu.ph',
      queryParameters: {
        'subject': 'App Issue Report',
        'body': 'Find an issue, Send it to us. We value your feedback, and are constantly trying to make the mobile app better.'
      },
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email client')),
      );
    }
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
              icon: const Icon(Icons.edit,
              color: Color.fromARGB(255, 249, 249, 249),),
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
              icon: const Icon(Icons.email,
              color: Color.fromARGB(255, 249, 249, 249),),
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
              icon: const Icon(Icons.lock_reset,
              color: Color.fromARGB(255, 249, 249, 249),),
              label: const Text('Change Password'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                alignment: Alignment.centerLeft,
              ),
            ),
            // _buildSectionTitle('Preferences'),
            // SwitchListTile(
            //   title: const Text('Notifications'),
            //   value: notificationsEnabled,
            //   onChanged: (val) {
            //     setState(() {
            //       notificationsEnabled = val;
            //     });
            //   },
            // ),
            // SwitchListTile(
            //   title: const Text('Dark Mode'),
            //   value: darkModeEnabled,
            //   onChanged: (val) {
            //     setState(() {
            //       darkModeEnabled = val;
            //     });
            //     // TODO: Implement actual dark mode toggle
            //   },
            // ),
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
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Terms of Service'),
                      content: const SingleChildScrollView(
                        child: Text(
                          'By using this educational app, you agree to our Terms of Service. '
                          'The app provides personalized learning content based on your preferences. '
                          'We strive to ensure content accuracy but do not guarantee specific results. '
                          'Users are responsible for their use of the app and must respect intellectual property rights.',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Privacy Policy'),
                      content: const SingleChildScrollView(
                        child: Text(
                          'This educational app respects your privacy. We collect minimal personal data necessary '
                          'to provide personalized learning experiences based on your preferences. '
                          'Your data is securely stored and not shared with third parties without your consent.',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text('Report an Issue'),
              onTap: _launchEmail,
            ),
          ],
        ),
      ),
    );
  }
}
