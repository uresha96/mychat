import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:mychat/chat/chat_state.dart';
import 'package:mychat/core/global_provider.dart';
import 'package:mychat/core/secure_storage.dart';
import 'package:mychat/messages/message.dart';

class ChatController extends StateNotifier<ChatState> {
  final String chatId;
  final Ref ref;
  final box = Hive.box<Message>('messages');

  ChatController(this.ref, this.chatId) : super(ChatState.initial()) {}

  Future<void> sendMessage(String text, int to) async {
    print("sendMessage");
    final socket = ref.read(socketProvider);
    socket.emit("chat_message", {"to": to, "message": text});

    print("Box length: ${box.length}");
    print("Messages in box: ${box.values.map((m) => m.text).toList()}");
    await box.add(
      Message(
        chatId: to.toString(),
        senderId: SecureStorage.instance.readData("userId").toString(),
        text: text,
        timestamp: DateTime.now(),
        isMine: true,
      ),
    );

    print("Box length: ${box.length}");
    print("Messages in box: ${box.values.map((m) => m.text).toList()}");
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
