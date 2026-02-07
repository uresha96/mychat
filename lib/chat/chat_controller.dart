import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/core/socket_server.dart';
import 'package:mychat/models/message.dart';

class ChatController extends StateNotifier<List<Message>> {
  final SocketService socket;
  final String chatId;

  ChatController(this.socket, this.chatId) : super([]) {
    socket.on('message', onMessage);
    loadInitial();
  }

  void loadInitial() {
    // TODO: vom Backend holen
    state = [
      Message(id: '1', text: 'Hi!', isMe: false),
      Message(id: '2', text: 'Hey 😄', isMe: true),
    ];
  }

  void onMessage(dynamic data) {
    state = [...state, Message.fromJson(data)];
  }

  void sendMessage(String text) {
    socket.emit('chat_message', {'to': chatId, 'text': text});
    state = [
      ...state,
      Message(
        id: DateTime.now().toString(),
        text: text,
        isMe: true,
      )
    ];
  }
}

// final chatProvider = StateNotifierProvider.family<ChatController, List<Message>,
//     SocketService, String>(
//   (ref, socket, chatId) => ChatController(socket, chatId),
// );
