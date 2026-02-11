import 'package:mychat/models/message.dart';

class ChatState {
  final List<Message> messages;
  final bool isOnline;

  ChatState({
    required this.messages,
    required this.isOnline,
  });

  factory ChatState.initial() => ChatState(
        messages: [],
        isOnline: false,
      );

  ChatState copyWith({
    List<Message>? messages,
    bool? isOnline,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
