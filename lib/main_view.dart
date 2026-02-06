import 'package:flutter/material.dart';
import 'package:mychat/chat_page.dart';
import 'package:mychat/models/chat.dart';

class ChatList extends StatelessWidget {
  ChatList({super.key});

  final List<Chat> chats = [Chat(name: "Buntu"), Chat(name: "amma")];
  final ScrollController scrollController = ScrollController();
  // @override
  // State<ChatList> createState() => ChatListState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return buildChatItem(chats[index], context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChatItem(Chat chat, BuildContext context) {
    return ListTile(
      title: Text(chat.name),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChatPage()),
        );
      },
    );
  }
}
