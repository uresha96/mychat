import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/chat/chat_state.dart';
import 'package:mychat/core/global_provider.dart';
import 'package:mychat/models/message.dart';

class ChatController extends StateNotifier<ChatState> {
  final String chatId;
  final Ref ref;

  ChatController(this.ref, this.chatId) : super(ChatState.initial()) {
    loadInitial();
  }

  void loadInitial() {
    state = state.copyWith(messages: [
      Message(id: '1', text: 'Hi!', isMe: false),
      Message(id: '2', text: 'Hey 😄', isMe: true),
    ]);
  }

  void onMessage(Message newMessage) {
    print("On Message");
    state = state.copyWith(messages: [...state.messages, newMessage]);
  }

  void sendMessage(String text, int to) {
    print("sendMessage");

    final socket = ref.read(socketProvider);
    socket.emit("chat_message", {"to": to, "message": text});
    state = state.copyWith(messages: [
      ...state.messages,
      Message(
        id: DateTime.now().toString(),
        text: text,
        isMe: true,
      )
    ]);
  }

  void setOnline(bool isOnline) {
    state = state.copyWith(isOnline: isOnline);
  }
}

final chatProvider =
    StateNotifierProvider.family<ChatController, ChatState, String>(
  (ref, chatId) {
    return ChatController(ref, chatId);
  },
);
