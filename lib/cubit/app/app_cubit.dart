import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:bloc/bloc.dart';
import 'package:social_media_app/data/model/chat.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media_app/data/model/user.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:social_media_app/config/app_config.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void userLoggedIn({required User user, required String token}) {
    emit(state.copyWith(user: user, token: token));
    // _connectSocket();
    _connectAndListen();
  }

  void _connectAndListen() {
    IO.Socket socket = IO.io(
        '${AppConfig.baseUrl}/messages?token=${state.token}',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket.connect();

    socket.onConnect((_) {
      print('SOCKET CONNECTED');
    });

    //When an event recieved from server, data is added to the stream
    socket.on('newMessage', (newMessage) {
      print(newMessage);
      final newChat = Chat.fromJson(newMessage);
      final newChats = [...state.chats, newChat];
      emit(state.copyWith(chats: newChats));
    });
    socket.onDisconnect((_) => print('disconnect'));
  }
}
