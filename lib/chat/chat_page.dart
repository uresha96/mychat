import 'package:flutter/material.dart';
import 'package:mychat/custom_widgets.dart';
import 'package:mychat/main_background.dart';
import 'package:mychat/models/chat.dart';
import 'package:mychat/models/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late io.Socket socket;

  @override
  void initState() {
    super.initState();
    // _initFCM();

    // // Listen for messages while app is in foreground
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("📨 Foreground message: ${message.notification?.title}");
    //   // Optional: show a snackbar or in-app alert
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(message.notification?.body ?? "New message")),
    //   );
    // });

    // FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    //   socket.emit("register_token", newToken);
    // });

    // socket = io.io(
    //   'http://192.168.178.60:3000',
    //   io.OptionBuilder()
    //       .setTransports(['websocket'])
    //       .disableAutoConnect()
    //       .build(),
    // );

    // socket.onConnect((_) {
    //   print('Connected to server!');
    //   socket.emit('message', 'Hello from Flutter');
    //   socket.emit('register_conversation', widget.chat.id);
    // });

    // socket.onDisconnect((_) {
    //   print('Disconnected from server');
    // });

    // socket.onConnectError((err) => print('ConnectError: $err'));
    // socket.onError((err) => print('Error: $err'));

    // socket.on('chat_message_reply', (data) {
    //   setState(() {
    //     messages.add(
    //       Message(
    //         id: "1",
    //         text: data.toString(),
    //         isMe: false,
    //       ),
    //     );
    //   });

    //   Future.delayed(const Duration(milliseconds: 100), () {
    //     scrollController.jumpTo(scrollController.position.maxScrollExtent);
    //   });
    // });
    // socket.connect();
  }

  final List<Message> messages = [];

  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;
    socket.emit("chat_message", controller.text.trim());

    setState(() {
      messages.add(
        Message(
          id: "2",
          text: controller.text.trim(),
          isMe: true,
        ),
      );
    });

    controller.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

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

  Widget buildInputArea() {
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
              onPressed: sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              buildInputArea(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  // void _initFCM() async {
  //   final fcm = FirebaseMessaging.instance;

  //   NotificationSettings settings = await fcm.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  //   print('User granted permission: ${settings.authorizationStatus}');

  //   String? token = await fcm.getToken();
  //   print("FCM Token: $token"); // send to server
  //   socket.emit("register_token", token);

  //   // Listen to foreground messages
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print("📨 Foreground message: ${message.notification?.body}");
  //   });
  // }
}
