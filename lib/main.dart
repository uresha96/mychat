import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mychat/auth/auth_controller.dart';
import 'package:mychat/chat/chat_list_page.dart';
import 'package:mychat/auth/login_view.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // This runs when app is terminated
//   print("📨 Background message: ${message.data}");
// }
final storage = FlutterSecureStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Initialize Firebase
  // await Firebase.initializeApp();

  // // Set background message handler
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // // Initialize FCM
  // final fcm = FirebaseMessaging.instance;

  // // Request notification permissions (iOS & Android)
  // NotificationSettings settings = await fcm.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  // print('User granted permission: ${settings.authorizationStatus}');

  // Get device token
  // String? token = await fcm.getToken();
  // print("FCM Token: $token"); // send this to your server
  runApp(
    ProviderScope(
      child: MyChat(),
    ),
  );
}

class MyChat extends ConsumerWidget {
  const MyChat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: auth.successfullyLoggedIn ? ChatList() : LoginView(),
    );
  }
}
