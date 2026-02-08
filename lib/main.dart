import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

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
