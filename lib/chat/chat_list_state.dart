import '../models/chat.dart';

class ChatListState {
  final bool isLoading;
  final List<Chat> chats;
  final String? error;

  ChatListState({
    required this.isLoading,
    required this.chats,
    this.error,
  });

  factory ChatListState.initial() => ChatListState(
        isLoading: false,
        chats: [],
        error: null,
      );

  ChatListState copyWith({
    bool? isLoading,
    List<Chat>? chats,
    String? error,
  }) {
    return ChatListState(
      isLoading: isLoading ?? this.isLoading,
      chats: chats ?? this.chats,
      error: error,
    );
  }
}
