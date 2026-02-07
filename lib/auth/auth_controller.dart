import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState.initial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Backend Call (HTTP oder Socket)
      await Future.delayed(const Duration(seconds: 1));

      // Simulierter Response
      const token = 'fake-jwt-token';
      const userId = 'user-123';

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        successfullyLoggedIn: true,
        token: token,
        userId: userId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Login fehlgeschlagen',
      );
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Backend Call
      await Future.delayed(const Duration(seconds: 1));

      const token = 'fake-jwt-token';
      const userId = 'user-123';

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        token: token,
        userId: userId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Signup fehlgeschlagen',
      );
    }
  }

  void logout() {
    // TODO: Token löschen + Socket trennen
    state = AuthState.initial();
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);
