import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/core/global_provider.dart';
import 'package:mychat/models/message.dart';

class ChatController extends StateNotifier<List<Message>> {
  final String chatId;
  final Ref ref;

  ChatController(this.ref, this.chatId) : super([]) {
    loadInitial();
  }

  void loadInitial() {
    // TODO: vom Backend holen
    state = [
      Message(id: '1', text: 'Hi!', isMe: false),
      Message(id: '2', text: 'Hey 😄', isMe: true),
    ];
  }

  void onMessage(Message newMessage) {
    print("On Message");
    state = [...state, newMessage];
  }

  void sendMessage(String text, int to) {
    print("sendMessage");

    final socket = ref.read(socketProvider);
    socket.emit("chat_message", {"to": to, "message": text});

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

final chatProvider =
    StateNotifierProvider.family<ChatController, List<Message>, String>(
  (ref, chatId) {
    return ChatController(ref, chatId);
  },
);
