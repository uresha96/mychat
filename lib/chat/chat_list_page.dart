import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/chat/add_chat_dialog.dart';
import 'package:mychat/chat/chat_list_controller.dart';
import 'package:mychat/chat/chat_list_state.dart';
import 'package:mychat/chat/chat_page.dart';
import 'package:mychat/main_background.dart';
import 'package:mychat/models/chat.dart';
import 'package:mychat/auth/settings_page.dart';

class ChatList extends ConsumerWidget {
  ChatList({super.key});

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/icons/logo_transparent.png",
              scale: 12,
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => SettingsPage(),
                      ));
                },
                icon: Icon(Icons.settings_outlined))
          ],
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddChatDialog(),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MainBackground(),
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              getWidget(chatState),
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
            title: Row(
              children: [
                Text(
                  chat.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
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
                      color: Colors.grey,
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
                  builder: (context) => ChatPage(chat: chat),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  getWidget(ChatListState chatState) {
    if (chatState.isLoading) {
      return CircularProgressIndicator();
    }

    if (chatState.error != null) {
      return Text(chatState.error!);
    }

    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: chatState.chats.length,
        itemBuilder: (context, index) {
          return buildChatItem(chatState.chats[index], context);
        },
      ),
    );
  }
}
