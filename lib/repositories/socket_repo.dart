import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/config/app_config.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketRepository {
  final AuthenticationCubit _authenticationCubit;
  IO.Socket? socket;

  SocketRepository(this._authenticationCubit);

  void initializeSocket() {
    if (socket != null) {
      return;
    }

    socket = IO.io('${AppConfig.baseUrl}/messages', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'token': _authenticationCubit.getToken()}
    });

    connect();
  }

  static SocketRepository? _instance;

  static SocketRepository get instance => _instance!;

  static setInstance(AuthenticationCubit authenticationCubit) {
    _instance ??= SocketRepository(authenticationCubit);
    return _instance;
  }

  void connect() async {
    socket?.connect();
    socket?.onConnect((_) {
      print('SOCKET CONNECTED');
      socket?.send(['Client ${socket?.id} just connected!']);
      socket?.emit('message', {"roomId": "1452761781910", "userId": "4"});
    });
    socket?.onConnectError((data) => print('SOCKET TIMEOUT - $data'));
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
