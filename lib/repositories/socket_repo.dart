import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/config/app_config.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final AuthenticationCubit _authenticationCubit;
  late IO.Socket socket;

  SocketRepository(this._authenticationCubit) {
    socket = IO.io(AppConfig.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'token': _authenticationCubit.getToken()}
    });
  }

  void connect() async {
    socket.connect();
    socket.onConnect((_) => print('SOCKET CONNECTED'));
    socket.onDisconnect((_) => print('disconnect'));
  }

  void listen(String event, Function(dynamic) callback) {
    socket.on(event, (data) => callback(data));
  }

  void send(String event, dynamic message) {
    socket.emit(event, message);
  }

  void close() {
    socket.disconnect();
    socket.close();
  }
}
