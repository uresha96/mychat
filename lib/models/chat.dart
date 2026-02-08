class Chat {
  final int id;
  final String name;
  final String avatar;
  final int withUser;

  Chat({
    required this.id,
    required this.name,
    required this.avatar,
    required this.withUser,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
      withUser: json['withUser'],
      avatar: json['avatar'] ??
          'https://upload.wikimedia.org/wikipedia/commons/b/bc/Unknown_person.jpg',
    );
  }
}
