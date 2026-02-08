class Message {
  String? id;
  final String text;
  final bool isMe;

  Message({
    this.id,
    required this.text,
    required this.isMe,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'],
      isMe: json['sender'] == 'me',
    );
  }
}
