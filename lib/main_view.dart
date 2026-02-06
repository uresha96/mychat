import 'package:flutter/material.dart';
import 'package:mychat/chat_page.dart';
import 'package:mychat/models/chat.dart';

class ChatList extends StatelessWidget {
  ChatList({super.key});

  final List<Chat> chats = [
    Chat(
      id: "1",
      name: "Buntu",
      avatar:
          "https://static.vecteezy.com/system/resources/previews/005/346/410/non_2x/close-up-portrait-of-smiling-handsome-young-caucasian-man-face-looking-at-camera-on-isolated-light-gray-studio-background-photo.jpg",
    ),
    Chat(
      id: "2",
      name: "amma",
      avatar:
          "https://i.ds.at/qTka4Q/rs:fill:750:0/plain/2018/11/16/14FEMALEPLEASURE-1.jpg",
    )
  ];
  final ScrollController scrollController = ScrollController();
  // @override
  // State<ChatList> createState() => ChatListState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage("assets/icons/mchat.png"),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          //const WaveBackground(),
          Column(
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
        ],
      ),
    );
  }

  Widget buildChatItem(Chat chat, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.88),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(chat.avatar),
            ),
            title: Text(
              chat.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              "lastMessage",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "time",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 6),
                if (10 > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A00E0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "10",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const ChatPage(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
