import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/core/dio_provider.dart';
import 'package:mychat/core/global_provider.dart';
import 'package:mychat/core/secure_storage.dart';
import 'package:mychat/core/socket_server.dart';
import 'package:mychat/models/user.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final SocketService socketService;
  var ref;

  AuthController(this.ref, this.socketService) : super(AuthState.initial());
  final Dio dio = DioClient.dio;
  final storage = SecureStorage();

  Future<void> login({
    required String email,
    required String password,
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

    try {
      Map<String, String> params = {"email": email, "password": password};
      final response = await dio.post("/users/login", queryParameters: params);
      dynamic data = response.data;
      print(data);

      if (response.statusCode == 200) {
        print("STATUS 200");

        var user = User.fromJson(data);
        storage.writeData("userId", user.id.toString());
        storage.writeData("userName", user.name);
        storage.writeData("userEmail", user.email);

        const token = 'fake-jwt-token';
        const userId = 'user-123';

        socketService.connect(token, user.id);
        socketService.setupListeners(ref);

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

  Future<void> logout() async {
    socketService.disconnect();
    //await storage.deleteAll();
    state = AuthState.initial();
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final socketService = ref.read(socketProvider);
    return AuthController(ref, socketService);
  },
);
