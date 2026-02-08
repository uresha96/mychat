import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/chat/chat_controller.dart';
import 'package:mychat/core/global_provider.dart';
import 'package:mychat/core/socket_server.dart';
import 'package:mychat/custom_widgets.dart';
import 'package:mychat/main_background.dart';
import 'package:mychat/models/chat.dart';
import 'package:mychat/models/message.dart';

class ChatPage extends ConsumerStatefulWidget {
  final Chat chat;
  const ChatPage({super.key, required this.chat});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Widget buildMessage(Message msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: msg.isMe ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isMe ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildInputArea(SocketService socket) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Expanded(
                child: inputTextField(
                    controller: controller, hint: 'Type a message...')),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (controller.text.trim().isEmpty) return;
                final notifier = ref.read(
                    chatProvider(widget.chat.withUser.toString()).notifier);
                notifier.sendMessage(
                    controller.text.trim(), widget.chat.withUser);

                setState(() {
                  controller.clear();
                  Future.delayed(const Duration(milliseconds: 100), () {
                    scrollController
                        .jumpTo(scrollController.position.maxScrollExtent);
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final socket = ref.read(socketProvider);
    final messages = ref.watch(chatProvider(widget.chat.withUser.toString()));

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.chat.avatar),
          ),
          SizedBox(
            width: 12,
          ),
          Text(widget.chat.name),
        ]),
      ),
      body: Stack(
        children: [
          MainBackground(),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return buildMessage(messages[index]);
                  },
                ),
              ),
              buildInputArea(socket),
            ],
          ),
        ],
      ),
    );
  }
}
