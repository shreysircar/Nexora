import 'package:flutter/material.dart';
import 'package:nexora_frontend/presentation/screens/splash_screen.dart'; 

void main() {
  runApp(NexoraApp());
}

class NexoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.tealAccent,
      ),
      home: SplashScreen(),
    );
  }
}