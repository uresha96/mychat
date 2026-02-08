import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/chat/chat_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/message.dart';

class SocketService {
  late IO.Socket socket;

  void connect(String token, int userId) {
    socket = IO.io(
      'http://192.168.178.60:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({"userId": userId})
          // .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }

  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void setupListeners(Ref ref) {
    socket.on("chat_message_reply", (data) {
      final from = data['from'].toString();

      final newMessage = Message(
        text: data['message'],
        isMe: false,
      );

      final chatController = ref.read(chatProvider(from).notifier);
      chatController.onMessage(newMessage);
    });
  }
}
