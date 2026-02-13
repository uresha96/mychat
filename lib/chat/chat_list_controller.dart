import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/core/dio_provider.dart';
import 'package:mychat/core/secure_storage.dart';
import 'package:mychat/models/chat.dart';

import 'chat_list_state.dart';

class ChatListController extends StateNotifier<ChatListState> {
  final Dio dio = DioClient.dio;
  final storage = SecureStorage();

  ChatListController() : super(ChatListState.initial()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    try {
      String userId = await storage.readData("userId");

      final response = await dio.get(
        "/users/$userId/chats",
      );

      final List<dynamic> data = response.data;
      var chatList = data.map((json) => Chat.fromJson(json)).toList();

      state = state.copyWith(
        isLoading: false,
        chats: chatList,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Adding chat failed: $e',
      );
    }
  }

  Future<void> addNewChat({
    required String name,
    required String email,
  }) async {
    print("ADD NEW CHAT");
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
      String userId = await storage.readData("userId");

      final response = await dio.post(
        "/users/$userId/new-chat",
        data: jsonEncode({"name": name, "email": email}),
      );

      var newChat = Chat.fromJson(response.data);

      // Update state with the new chat
      state = state.copyWith(
        isLoading: false,
        chats: [...state.chats, newChat],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Adding chat failed: $e',
      );
    }
  }
}

final chatListProvider =
    StateNotifierProvider<ChatListController, ChatListState>(
  (ref) => ChatListController(),
);
