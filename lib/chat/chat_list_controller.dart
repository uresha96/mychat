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
      String userId = await storage.readData("userId") ?? '';

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
    // state = state.copyWith(
    //   chats: [
    //     Chat(
    //       id: 1,
    //       name: "Buntu",
    //       avatar:
    //           "https://static.vecteezy.com/system/resources/previews/005/346/410/non_2x/close-up-portrait-of-smiling-handsome-young-caucasian-man-face-looking-at-camera-on-isolated-light-gray-studio-background-photo.jpg",
    //     ),
    //     Chat(
    //       id: 2,
    //       name: "Amma",
    //       avatar:
    //           "https://i.ds.at/qTka4Q/rs:fill:750:0/plain/2018/11/16/14FEMALEPLEASURE-1.jpg",
    //     ),
    //   ],
    // );
  }

  Future<void> addNewChat({
    required String name,
    required String email,
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
      String userId = await storage.readData("userId") ?? '';

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
