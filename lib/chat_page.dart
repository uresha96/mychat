import 'package:flutter/material.dart';
import 'package:mychat/models/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

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

    socket = io.io(
      'http://192.168.178.60:3000',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print('Connected to server!');
      socket.emit('message', 'Hello from Flutter');
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    socket.onConnectError((err) => print('ConnectError: $err'));
    socket.onError((err) => print('Error: $err'));

    socket.on('chat_message_reply', (data) {
      setState(() {
        messages.add(
          Message(
            text: data.toString(),
            isMe: false,
            time: DateTime.now(),
          ),
        );
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    });
    socket.connect();
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
          text: controller.text.trim(),
          isMe: true,
          time: DateTime.now(),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => sendMessage(),
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: sendMessage,
            child: const Icon(Icons.send),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// Messages list
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),

          /// Input area
          buildInputArea(),
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
