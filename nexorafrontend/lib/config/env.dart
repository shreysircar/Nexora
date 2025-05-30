//const String baseUrl = "http://localhost:5000"; // or your hosted backend URL

// config/env.dart
import 'package:flutter/foundation.dart';

class Env {
  // Base URL configuration with compile-time constant
  static String baseUrl = _kBaseUrl;

  // Private constants for different environments
  static const String _kProdUrl = 'https://api.nexora.com';
  static const String _kDevUrl = 'http://10.0.2.2:5000';       //android emulators
  static const String _kFallbackUrl = 'http://localhost:5000';   //physical devices

  // Non-constant getter for runtime environment detection
  static String get _kBaseUrl {
    if (kReleaseMode) return _kProdUrl;
    if (kDebugMode) return _kDevUrl;
    return _kFallbackUrl;
  }

  // Environment flags (can be constants)
  static const bool isProduction = kReleaseMode;
  static const bool isDebug = kDebugMode;

  // Method to get URL with optional override
  static String getBaseUrl({String? override}) {
    return override ?? _kBaseUrl;
  }
}