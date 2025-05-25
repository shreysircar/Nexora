import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF12001A),
              Color(0xFF4A1E6B),
              Color(0xFFC724B1),
            ],
            stops: [0.0, 0.5, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/Nexora_color.png',
                width: 180,
                height: 180,
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Text(
                "Nexora",
                textAlign: TextAlign.center,
                style: GoogleFonts.brunoAceSc(
  textStyle: TextStyle(
    fontSize: 36,
    color: const Color.fromARGB(255, 232, 183, 234),
  ),
)
              ),
            ),
          ],
        ),
      ),
    );
  }
}