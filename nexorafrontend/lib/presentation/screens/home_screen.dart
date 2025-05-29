import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexora Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.offAllNamed(AppRoutes.login),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Nexora',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Using only existing routes
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.register),
              child: const Text('Go to Register Screen'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(AppRoutes.splash),
              child: const Text('Return to Splash'),
            ),
          ],
        ),
      ),
    );
  }
}