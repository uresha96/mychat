import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/core/dio_provider.dart';
import 'package:mychat/core/secure_storage.dart';
import 'package:mychat/models/user.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState.initial());
  final Dio dio = DioClient.dio;
  final storage = SecureStorage();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      Map<String, String> params = {"email": email, "password": password};
      final response = await dio.post("/users/login", queryParameters: params);
      dynamic data = response.data;
      print(data);

      if (response.statusCode == 200) {
        print("STATUS 200");

        try {
          var user = User.fromJson(data);
          storage.writeData("userId", user.id.toString());
          storage.writeData("userName", user.name);
          storage.writeData("userEmail", user.email);
        } catch (e) {
          print(e);
        }

        const token = 'fake-jwt-token';
        const userId = 'user-123';

        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          successfullyLoggedIn: true,
          token: token,
          userId: userId,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          successfullyLoggedIn: false,
          error: data.toString(),
        );
      }
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
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ));

    print(dio.options.baseUrl);
    try {
      final response = await dio.post("/users",
          data: jsonEncode(
              {"email": email, "password": password, "name": username}));

      print(response);
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
