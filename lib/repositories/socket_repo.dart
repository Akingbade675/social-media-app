import 'package:social_media_app/config/app_config.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  IO.Socket? socket;

  static SocketClient? _instance;

  static SocketClient instance({String token = ''}) {
    _instance ??= SocketClient._internal(token);
    return _instance!;
  }

  SocketClient._internal(String token) {
    socket = IO.io('${AppConfig.baseUrl}/messages', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'token': token}
    });
  }

  void connect() async {
    socket?.connect();
    socket?.onConnect((_) {
      print('SOCKET CONNECTED');
      socket?.send(['Client ${socket?.id} just connected!']);
      socket?.emit('message', {"roomId": "1452761781910", "userId": "4"});
    });
    socket?.onConnectError((data) => print('SOCKET Error - $data'));
    socket?.onConnectTimeout((data) => print('SOCKET TIMEOUT - $data'));
    socket?.onDisconnect((_) => print('disconnect'));
  }

  void listen(String event, Function(dynamic) callback) {
    socket?.on(event, (data) => callback(data));
  }

  void send(String event, dynamic message) {
    print('Emitting $event');
    socket?.emit(event, message);
  }

  void close() {
    socket?.dispose();
  }
}
