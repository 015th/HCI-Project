import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('extend',
        style: TextStyle(
            fontSize: 25,
            color: Colors.cyan,
            shadows: [
              Shadow(
                offset: const Offset(0, 4),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.25)
              )
            ],
            ),
            ),
        centerTitle: true,
      ),
    ); //Scaffold
  }
}