import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/constants.dart';
import '../../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await AuthService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        Get.offAllNamed(AppRoutes.home);
      } on DioException catch (e) {
        String errorMessage = "Login failed";
        if (e.response?.statusCode == 401) {
          errorMessage = "Invalid email or password";
        } else if (e.response?.data != null) {
          errorMessage = e.response!.data['message'] ?? errorMessage;
        }

        Get.snackbar(
          "Error",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,  // <-- Key change here
          backgroundColor: Colors.white,
          colorText: Colors.black87,
          borderWidth: 1,
          borderColor: Colors.grey[300],
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          forwardAnimationCurve: Curves.easeOutCubic,  // Smooth slide-up
          reverseAnimationCurve: Curves.easeInCubic,   // Smooth slide-down
          animationDuration: const Duration(milliseconds: 400),
        );
      } catch (e) {
        Get.snackbar(
          "Error",
          "An unexpected error occurred",
          snackPosition: SnackPosition.BOTTOM,  // <-- Consistent positioning
          backgroundColor: Colors.white,
          colorText: Colors.black87,
          borderWidth: 1,
          borderColor: Colors.grey[300],
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image layer
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_bck.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Elevated sliding panel (positioned higher)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF604683).withOpacity(0.65),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: pagePadding.copyWith(top: 40),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Nexora',
                          style: GoogleFonts.brunoAceSc(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFE6EEFA),
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white70),
                          validator: (value) => value!.isEmpty ? 'Enter email' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) => value!.isEmpty ? 'Enter password' : null,
                        ),
                        const SizedBox(height: 30),
                        _isLoading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : ElevatedButton(
                          onPressed: _loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA60ED5),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () => Get.to(() => const RegisterScreen()),
                          child: const Text(
                            "Don't have an account? Register",
                            style: TextStyle(
                              color: Colors.white70,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}