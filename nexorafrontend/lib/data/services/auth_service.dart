/*import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nexora_frontend/config/env.dart';

class AuthService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),

    validateStatus: (status) => status! < 500,
  ));

  static const _storage = FlutterSecureStorage();

  // Initialize with interceptor
  static void init() {
    _dio.interceptors.add(_AuthInterceptor());
  }

  static Future<bool> login(String email, String password) async {
    try {
      final res = await _dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );

      return _handleAuthResponse(res);
    } on DioException catch (e) {
      print('Login error: ${e.response?.data}');
      rethrow;
    }
  }

  static Future<bool> register(String username, String email, String password) async {
    try {
      final res = await _dio.post(
        '/api/auth/register',
        data: {'username': username, 'email': email, 'password': password},
      );
      return _handleAuthResponse(res);
    } on DioException catch (e) {
      print('Register error: ${e.response?.data}');
      rethrow;
    }
  }

  static bool _handleAuthResponse(Response res) {
    if (res.statusCode == 200) {
      final token = res.data['token'];
      if (token != null) {
        _storage.write(key: 'auth_token', value: token);
        return true;
      }
    }
    throw DioException(
      requestOptions: res.requestOptions,
      response: res,
      error: res.data['message'] ?? 'Authentication failed',
    );
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}

// Private interceptor class
class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await AuthService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}*/

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nexora_frontend/config/env.dart';

class AuthService {
  static final Dio _dio = Dio();
  static const _storage = FlutterSecureStorage();

  static Future<void> init() async{
    // Initialize Dio with current baseUrl
    _dio.options = BaseOptions(
      baseUrl: await _getEffectiveBaseUrl(),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json', // Add this
      },
      validateStatus: (status) => status! < 500,
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(),
      if (kDebugMode) LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }

  static Future<String> _getEffectiveBaseUrl() async {  // Changed to async
    const String? commandLineUrl = String.fromEnvironment('BASE_URL');
    if (commandLineUrl != null && commandLineUrl.isNotEmpty) {
      return commandLineUrl;
    }

    if (kReleaseMode) {
      return 'https://api.nexora.com';
    }
    return await Env.baseUrl;  // Added await
  }

  static Future<bool> login(String email, String password) async {
    try {
      final res = await _dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );
      return _handleAuthResponse(res);
    } on DioException catch (e) {
      _logError('Login', e);
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> register(
      String username,
      String email,
      String password,
      ) async {
    try {
      final res = await _dio.post(
        '/api/auth/register',
        data: {'username': username, 'email': email, 'password': password},
      );

      if (res.statusCode == 200) {
        final token = res.data['token'];
        if (token != null) {
          await _storage.write(key: 'auth_token', value: token);
          return {'success': true, 'token': token};
        }
        return {'success': false, 'error': 'Token missing'};
      }

      return {
        'success': false,
        'error': res.data['msg'] ?? 'Registration failed',
      };

    } on DioException catch (e) {
      _logError('Register', e);
      return {
        'success': false,
        'error': e.response?.data['msg'] ?? e.message ?? 'Registration failed',
      };
    }
  }
  static void _logError(String operation, DioException e) {
    debugPrint('''
$operation error:
- URL: ${e.requestOptions.uri}
- Method: ${e.requestOptions.method}
- Status: ${e.response?.statusCode}
- Error: ${e.response?.data ?? e.message}
''');
  }

  static bool _handleAuthResponse(Response res) {
    if (res.statusCode == 200) {
      final token = res.data['token'];
      if (token != null) {
        _storage.write(key: 'auth_token', value: token);
        return true;
      }
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        error: 'Token missing in response',
      );
    }

    // Handle specific error cases
    if (res.statusCode == 400) {
      final errorMsg = res.data['msg'] ?? 'Bad request';
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        error: errorMsg, // Preserve the server's message
        type: DioExceptionType.badResponse,
      );
    }

    // Generic error case
    throw DioException(
      requestOptions: res.requestOptions,
      response: res,
      error: res.data['message'] ?? 'Authentication failed (Status: ${res.statusCode})',
    );
  }

  static Future<void> logout() async => await _storage.delete(key: 'auth_token');
  static Future<String?> getToken() async => await _storage.read(key: 'auth_token');
}

class _AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await AuthService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
