import 'package:flutter/material.dart';
import 'package:mychat/login_view.dart';
import 'package:mychat/main_view.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // This runs when app is terminated
//   print("📨 Background message: ${message.data}");
// }

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
  runApp(const MyChat());
}

class MyChat extends StatelessWidget {
  const MyChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: LoginView(),
    );
  }
}
