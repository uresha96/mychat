import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:mychat/chat/chat_controller.dart';
import 'package:mychat/chat/chat_list_controller.dart';
import 'package:mychat/models/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../messages/message.dart';

class SocketService {
  late IO.Socket socket;
  final box = Hive.box<Message>('messages');

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
    socket.on("chat_message_reply", (data) async {
      print(data);
      final from = data['from'].toString();

      await box.add(
        Message(
          chatId: from,
          senderId: from,
          text: data['message'],
          timestamp: DateTime.now(),
          isMine: false,
        ),
      );

      final chatExists = ref
          .read(chatListProvider)
          .chats
          .any((chat) => chat.withUser == int.parse(from));

      if (!chatExists) {
        final senderName = data['senderName'].toString();
        final senderEmail = data['senderEmail'].toString();

        ref
            .read(chatListProvider.notifier)
            .addNewChat(name: senderName, email: senderEmail);
      }
    });

    socket.on("user_connected", (data) {
      print(data);
      final chatController = ref.read(chatProvider(data.toString()).notifier);
      chatController.setOnline(true);
    });
    socket.on("user_disconnected", (data) {
      print(data);
      final chatController = ref.read(chatProvider(data.toString()).notifier);
      chatController.setOnline(false);
    });
  }
}
