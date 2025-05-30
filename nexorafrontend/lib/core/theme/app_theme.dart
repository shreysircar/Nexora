import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.pinkAccent,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF1E6FA), // Light purple background
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF1E6FA), // Matches scaffold
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFDF57DE)), // Purple icons
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFDF57DE), // Purple icons throughout app
      size: 24, // Default icon size
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFAA0EA4), // Deep magenta
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF1E1226), // Dark purpleish-grey
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1226), // Matches scaffold
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFDF57DE)), // Purple icons
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFDF57DE), // Purple icons throughout app
      size: 24, // Default icon size
    ),
  );
}