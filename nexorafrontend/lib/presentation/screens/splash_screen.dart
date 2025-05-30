import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart'; // Add this import
import '../routes/app_routes.dart'; // Import your routes

class SplashScreen extends StatefulWidget { // Changed to StatefulWidget
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Add any initialization logic here (like checking auth status)
    await Future.delayed(Duration(seconds: 6)); // Show splash for 2 seconds

    // Navigate to your desired screen (login as example)
    Get.offNamed(AppRoutes.login); // or AppRoutes.home if already authenticated
  }

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
                'assets/images/Nexora_white1.png',
                width: 200,
                height: 200,
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
                      color: const Color.fromARGB(255, 240, 210, 241),
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