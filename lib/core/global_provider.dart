import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mychat/core/socket_server.dart';

final socketProvider = Provider<SocketService>((ref) {
  final socket = SocketService();
  //socket.setupListeners(ref);
  ref.onDispose(socket.disconnect);
  return socket;
});
