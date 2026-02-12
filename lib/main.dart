import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mychat/auth/auth_controller.dart';
import 'package:mychat/chat/chat_list_page.dart';
import 'package:mychat/auth/login_view.dart';
import 'package:mychat/core/theme_provider.dart';
import 'package:mychat/messages/message.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // This runs when app is terminated
//   print("📨 Background message: ${message.data}");
// }
final storage = FlutterSecureStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(MessageAdapter());
  await Hive.openBox<Message>('messages');

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
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      //darkTheme: ThemeData.dark(useMaterial3: true),
      home: authState.isAuthenticated ? ChatList() : const LoginView(),
    );
  }
}
