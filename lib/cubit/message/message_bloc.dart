// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:social_media_app/data/model/user.dart';
import 'package:social_media_app/data/service/create_message_service.dart';
import 'package:social_media_app/data/service/notification_service.dart';
import 'package:social_media_app/repositories/socket_repo.dart';

import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/data/model/chat.dart';
import 'package:social_media_app/data/service/get_chats.dart';

enum TypingStatus { send, received }

class ChatBloc extends HydratedBloc<ChatEvent, ChatState> {
  final AuthenticationCubit _authenticationCubit;
  late SocketClient _socketClient;
  RestartableTimer? _timer;
  TypingState? previousTypingState;

  ChatBloc(this._authenticationCubit) : super(const ChatState()) {
    _socketClient = SocketClient.instance();

    on<ChatStarted>(_onStarted);
    on<ChatReceived>(_onReceived);
    on<ChatSent>(_onSent);
    on<TypingEvent>(_onTyping);
  }

  _resetOrStartTimer(Emitter<ChatState> emit) {
    if (_timer == null) {
      _timer = RestartableTimer(
        const Duration(seconds: 3),
        () => {
          _timer = null,
          emit(state.copyWith(
            typingState: const TypingState(isTyping: false),
          )),
        },
      );
    } else {
      _timer!.reset();
    }
  }

  _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    // if (state.chats.isEmpty) {
    //   final chats = await _getChats();
    //   emit(state.copyWith(chats: chats));
    // } else {
    //   final lastMsg = state.chats.last.createdAt;
    //   final chats = await _getChats();
    //   emit(state.copyWith(chats: [...state.chats, ...chats]));
    // }
    final chats =
        await GetChatsService(token: _authenticationCubit.getToken(), page: 0)
            .call();
    emit(state.copyWith(chats: chats));
    registerChatListeners();
  }

  _onSent(ChatSent event, Emitter<ChatState> emit) async {
    final message = event.message.trim();
    // final chat = Chat(
    //   id: '1',
    //   message: event.message,
    //   user: _authenticationCubit.getUser()!,
    //   createdAt: DateTime.now(),
    // );
    // socket.emit('newMessage', chat.toMap());
    // emit(state.copyWith(chats: [chat, ...state.chats]));

    if (message.isEmpty) return;

    try {
      await CreateMessageService(
        message: message,
        token: _authenticationCubit.getToken(),
      ).call();
    } catch (e) {
      print(e);
    }
  }

  _onReceived(ChatReceived event, Emitter<ChatState> emit) async {
    final chat = event.chat;
    // final index = state.chats.indexWhere((c) => c.id == chat.id);
    // if (index == -1) {
    //   emit(state.copyWith(chats: [...state.chats, chat]));
    // } else {
    //   final chats = state.chats;
    //   chats[index] = chat;
    //   emit(state.copyWith(chats: chats));
    // }
    emit(state.copyWith(chats: [chat, ...state.chats]));
  }

  @override
  ChatState? fromJson(Map<String, dynamic> json) {
    return ChatState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ChatState state) {
    // Check if the typingState has changed
    final typingStateChanged = state.typingState != previousTypingState;

    // Store the current state as the previous state
    previousTypingState = state.typingState;

    // Only save the state if typingState has not changed
    if (!typingStateChanged) {
      return state.toJson();
    } else {
      return null;
    }
  }

  void registerChatListeners() async {
    _socketClient.listen('newMessage', (newMessage) {
      final newChat = Chat.fromMap(newMessage);
      add(ChatReceived(chat: newChat));
      NotificationService.showNotification(
        title: newMessage['user']['name'],
        body: newMessage['message'],
        notificationType: NotificationType.message,
        // payload: {
        //   'chatId': newChat.id,
        // },
      );
    });

    _socketClient.listen('typing', (typingMessage) {
      final User user = typingMessage['user'];
      print('Someone is typing...');
      add(TypingEvent(
        user: user,
        status: TypingStatus.received,
      ));
    });
    print('Chat listeners registered');
  }

  FutureOr<void> _onTyping(TypingEvent event, Emitter<ChatState> emit) {
    final User user = event.user;
    final TypingStatus status = event.status;
    print('I am typing...');
    if (status == TypingStatus.send) {
      _socketClient.send('typing', {
        'user': user,
      });
    } else {
      emit(
          state.copyWith(typingState: TypingState(isTyping: true, user: user)));
      _resetOrStartTimer(emit);
    }
  }
}

sealed class ChatEvent {}

final class ChatStarted extends ChatEvent {}

final class TypingState extends Equatable {
  final bool isTyping;
  final User? user;

  const TypingState({this.user, required this.isTyping});

  @override
  List<Object?> get props => [isTyping, user?.id];
}

final class TypingEvent extends ChatEvent {
  final User user;
  final TypingStatus status;

  TypingEvent({required this.status, required this.user});
}

final class ChatSent extends ChatEvent {
  final String message;

  ChatSent({required this.message});
}

final class ChatReceived extends ChatEvent {
  final Chat chat;

  ChatReceived({required this.chat});
}

final class ChatUpdated extends ChatEvent {
  final Chat chat;

  ChatUpdated({required this.chat});
}

final class ChatDeleted extends ChatEvent {
  final String chatId;

  ChatDeleted({required this.chatId});
}

final class ChatRead extends ChatEvent {
  final String chatId;

  ChatRead({required this.chatId});
}

final class ChatUnread extends ChatEvent {
  final String chatId;

  ChatUnread({required this.chatId});
}

final class ChatError extends ChatEvent {
  final String error;

  ChatError({required this.error});
}

final class ChatClear extends ChatEvent {}

// class ChatStates extends Equatable {
//   const ChatStates();

//   @override
//   List<Object?> get props => [];
// }

class ChatState extends Equatable {
  final List<Chat> chats;
  final TypingState? typingState;
  final int unread;

  const ChatState({this.typingState, this.unread = 0, this.chats = const []});

  ChatState copyWith(
      {List<Chat>? chats, int? unread, TypingState? typingState}) {
    return ChatState(
      chats: chats ?? this.chats,
      unread: unread ?? this.unread,
      typingState: typingState ?? this.typingState,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chats': chats.map((chat) => chat.toMap()).toList(),
      'unread': unread,
    };
  }

  factory ChatState.fromJson(Map<String, dynamic> map) {
    return ChatState(
      chats: List<Chat>.from(map['chats']?.map((x) => Chat.fromMap(x))),
      unread: map['unread'],
    );
  }

  @override
  List<Object> get props => [chats];
}
