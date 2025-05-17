import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/Extend.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();

        // Navigate to Home after video ends
        _controller.addListener(() {
          if (!_controller.value.isPlaying && _controller.value.position == _controller.value.duration) {
            Navigator.pushReplacementNamed(context, '/question');
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // Prevent back navigation
    child: Scaffold(
       backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    ),
    );
  }
}
