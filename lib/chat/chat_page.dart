import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mychat/chat/chat_controller.dart';
import 'package:mychat/core/global_provider.dart';
import 'package:mychat/core/socket_server.dart';
import 'package:mychat/custom_widgets.dart';
import 'package:mychat/main_background.dart';
import 'package:mychat/messages/message.dart';
import 'package:mychat/models/chat.dart';

class ChatPage extends ConsumerStatefulWidget {
  final Chat chat;
  const ChatPage({super.key, required this.chat});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Widget buildMessage(Message msg) {
    return Align(
      alignment: msg.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: msg.isMine
              ? const Color.fromARGB(255, 149, 196, 234)
              : const Color.fromARGB(255, 212, 237, 218),
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicWidth(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  msg.text,
                  style: TextStyle(
                    // color: msg.isMine ? Colors.black : Colors.black,
                    fontSize: 16,
                  ),
                  softWrap: true,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    // color: msg.isMine ? Colors.black : Colors.black,
                    fontSize: 8,
                  ),
                ),
              ]),
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
                  scrollToBottom();
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
    final chatState = ref.watch(chatProvider(widget.chat.withUser.toString()));

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // shadowColor: Colors.white,
        title: Row(children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.chat.avatar),
          ),
          SizedBox(
            width: 12,
          ),
          Text(widget.chat.name),
          SizedBox(
            width: 12,
          ),
          Icon(chatState.isOnline ? Icons.online_prediction_sharp : null)
        ]),
      ),
      body: Stack(
        children: [
          MainBackground(),
          Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<Message>('messages').listenable(),
                  builder: (context, Box<Message> box, _) {
                    final messages = box.values
                        .where(
                            (m) => m.chatId == widget.chat.withUser.toString())
                        .toList()
                      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      scrollToBottom();
                    });

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return buildMessage(messages[index]);
                      },
                    );
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
