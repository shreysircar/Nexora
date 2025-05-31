import 'package:riverpod/riverpod.dart';
import 'package:nexora_frontend/data/services/auth_service.dart';
import 'package:dio/dio.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;
  final String? token;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
    this.token,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
    String? token,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
      token: token,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = await AuthService.getToken();
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: token != null,
        token: token,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to check authentication status',
      );
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await AuthService.login(email, password);
      if (success) {
        final token = await AuthService.getToken();
        _updateState(authenticated: true, token: token);
        return true;
      } else {
        _updateState(error: 'Login failed (no token received)');
        return false;
      }
    } on DioException catch (e) {
      _updateState(error: e.response?.data['message'] ?? e.message ?? 'Login failed');
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await AuthService.register(username, email, password);
      if (result['success'] == true) {
        _updateState(authenticated: true, token: result['token']);
        return true;
      } else {
        _updateState(error: result['error'] ?? 'Registration failed');
        return false;
      }
    } on DioException catch (e) {
      _updateState(error: e.response?.data['msg'] ?? e.message ?? 'Registration failed');
      return false;
    }
  }

  void logout() async {
    await AuthService.logout();
    state = const AuthState();
  }

  void _updateState({bool authenticated = false, String? token, String? error}) {
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: authenticated,
      token: token,
      error: error,
    );
  }
}