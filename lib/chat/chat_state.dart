class ChatState {
  final bool isOnline;

  ChatState({
    required this.isOnline,
  });

  factory ChatState.initial() => ChatState(
        isOnline: false,
      );

  ChatState copyWith({
    bool? isOnline,
  }) {
    return ChatState(
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
