import 'package:socket_io_client/socket_io_client.dart' as io;

io.Socket connectSocketClient() {
  print("connectSocketClient");
  io.Socket socket = io.io(
      'ws://192.168.178.60:3000', // or your server IP
      io.OptionBuilder().setTransports(['websocket']) // important
          .build());
  socket.onConnect((_) {
    print('############ connect');
    socket.emit('chat_message', 'test');
  });
  socket.onConnectError((err) => print('ConnectError: $err'));
  socket.onError((err) => print('Error: $err'));
  socket.onDisconnect((_) => print('Disconnected'));

  socket.connect();

  print(socket.connected);
  return socket;
}
