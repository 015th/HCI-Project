import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isHovering = false;

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'By using this app, you agree to the collection and use of information in accordance with this policy. '
            'We only collect the minimum data required to provide and improve our services. '
            'Your data is stored securely and never sold to third parties. '
            'We may share information only as required by law or to protect our rights. '
            'For questions, contact support.',
            style: TextStyle(fontSize: 15),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmation'),
                  content: const Text(
                      'Are you sure you want to agree and continue?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Yes, I Agree'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                Navigator.of(context).pop(); // Close the privacy policy dialog
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Agree and Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Big "extend" text
                    const Text(
                      'extend',
                      style: TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 50,
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 8,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),

                    // Subtitle
                    const Text(
                      'Start your learning journey with personalized courses from leading educators and industry experts, tailored to fit your unique goals and schedule.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontFamily: 'Nunito Sans',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Continue with Google button
                    SizedBox(
                      width: double.infinity,
                      height: 49,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: const BorderSide(color: Colors.black26),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Implement Google sign-in
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Use your Google logo asset if available:
                            // Image.asset('assets/google_logo.png', height: 22, width: 22),
                            Icon(Icons.g_mobiledata,
                                color: Colors.red, size: 28), // Placeholder
                            const SizedBox(width: 8),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    const Divider(thickness: 1, color: Colors.black12),
                    const SizedBox(height: 18),

                    // Log in with Email button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: 2,
                        ),
                        child: const Text('Log in with Email'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Create Account link with hover effect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'New to Extend? ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Nunito Sans',
                            fontSize: 15,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => _isHovering = true),
                          onExit: (_) => setState(() => _isHovering = false),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                color: _isHovering
                                    ? Colors.blueAccent
                                    : Colors.cyan,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Nunito Sans',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40), // Space before privacy policy
                  ],
                ),
              ),
            ),
            // Privacy Policy at the very bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(
                child: GestureDetector(
                  onTap: _showPrivacyPolicyDialog,
                  child: const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
