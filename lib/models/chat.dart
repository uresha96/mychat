class Chat {
  final int id;
  final String name;
  final String avatar;

  Chat({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}
