// config/env.dart
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class Env {
  // Private constants for all environments
  static const String _kProdUrl = 'https://api.nexora.com';
  static const String _kDevEmulatorUrl = 'http://10.0.2.2:5000';
  static const String _kDevPhysicalUrl = 'http://192.168.1.10:5000'; // ← Replace with your local IP
  static const String _kLocalhostUrl = 'http://localhost:5000';

  // Synchronous getter for non-async contexts (e.g., main())
  static String get baseUrlSync {
    if (kReleaseMode) return _kProdUrl;
    if (kDebugMode && Platform.isAndroid) return _kDevEmulatorUrl; // Most common dev case
    return _kLocalhostUrl; // Fallback
  }

  // Async getter with precise device detection
  static Future<String> get baseUrl async {
    if (kReleaseMode) return _kProdUrl;

    // Handle mobile platforms
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        final isEmulator = await _isEmulator();
        return isEmulator ? _kDevEmulatorUrl : _kDevPhysicalUrl;
      } catch (e) {
        debugPrint('Device detection error: $e');
        return _kDevPhysicalUrl; // Fail-safe to physical device URL
      }
    }

    // Default for web/desktop
    return _kLocalhostUrl;
  }

  static Future<bool> _isEmulator() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return !androidInfo.isPhysicalDevice; // True for emulator
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return !iosInfo.isPhysicalDevice; // True for simulator
    }
    return false; // Non-mobile platforms
  }

  // Environment flags
  static const bool isProduction = kReleaseMode;
  static const bool isDebug = kDebugMode;

  // Helper to print current config (debug only)
  static Future<void> logCurrentConfig() async {
    if (kDebugMode) {
      debugPrint('Environment Configuration:');
      debugPrint('- Mode: ${isProduction ? 'Production' : 'Development'}');
      debugPrint('- Platform: ${Platform.operatingSystem}');
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final isEmulator = await _isEmulator();
        debugPrint('- Device: ${isEmulator ? 'Emulator' : 'Physical'}');
      }
      debugPrint('- API URL: ${await baseUrl}');
    }
  }
}