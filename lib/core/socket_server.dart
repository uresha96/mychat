import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/chat/chat_controller.dart';
import 'package:mychat/chat/chat_list_controller.dart';
import 'package:mychat/models/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/message.dart';

class SocketService {
  late IO.Socket socket;

  void connect(String token, User user) {
    print(user);

    socket = IO.io(
      'http://192.168.178.60:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({
            "userId": user.id,
            "userName": user.name,
            "userEmail": user.email
          })
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
      print(data);
      final from = data['from'].toString();

      final newMessage = Message(
        text: data['message'],
        isMe: false,
      );

      final chatController = ref.read(chatProvider(from).notifier);
      final chatExists =
          ref.read(chatListProvider).chats.any((chat) => chat.withUser == from);

      if (!chatExists) {
        final senderName = data['senderName'].toString();
        final senderEmail = data['senderEmail'].toString();

        ref
            .read(chatListProvider.notifier)
            .addNewChat(name: senderName, email: senderEmail);
      }
      chatController.onMessage(newMessage);
    });
  }
}
