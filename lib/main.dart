import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(SamvidhanArcadeApp());
}

class SamvidhanArcadeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Samvidhan Arcade',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}