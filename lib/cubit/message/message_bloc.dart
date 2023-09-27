// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:async/async.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:social_media_app/data/model/user.dart';
import 'package:social_media_app/data/service/create_message_service.dart';
import 'package:social_media_app/repositories/socket_repo.dart';

import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/data/model/chat.dart';
import 'package:social_media_app/data/service/get_chats.dart';

enum TypingStatus { send, received }

class ChatBloc extends HydratedBloc<ChatEvent, ChatStates> {
  final AuthenticationCubit _authenticationCubit;
  late SocketRepository _socketRepository;
  RestartableTimer? _timer;

  ChatBloc(this._authenticationCubit) : super(const ChatState()) {
    _socketRepository = SocketRepository(_authenticationCubit);

    on<ChatStarted>(_onStarted);
    on<ChatReceived>(_onReceived);
    on<ChatSent>(_onSent);
    on<TypingEvent>(_onTyping);
  }

  _resetOrStartTimer(Emitter<ChatStates> emit) {
    if (_timer == null) {
      _timer = RestartableTimer(
        const Duration(seconds: 3),
        () => {
          _timer = null,
          emit(
            const TypingState(isTyping: false),
          ),
        },
      );
    } else {
      _timer!.reset();
    }
  }

  _onStarted(ChatStarted event, Emitter<ChatStates> emit) async {
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
    emit((state as ChatState).copyWith(chats: chats));
    _connectAndListen();
  }

  _onSent(ChatSent event, Emitter<ChatStates> emit) async {
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

  _onReceived(ChatReceived event, Emitter<ChatStates> emit) async {
    final chat = event.chat;
    // final index = state.chats.indexWhere((c) => c.id == chat.id);
    // if (index == -1) {
    //   emit(state.copyWith(chats: [...state.chats, chat]));
    // } else {
    //   final chats = state.chats;
    //   chats[index] = chat;
    //   emit(state.copyWith(chats: chats));
    // }
    emit((state as ChatState)
        .copyWith(chats: [chat, ...(state as ChatState).chats]));
  }

  @override
  ChatState? fromJson(Map<String, dynamic> json) {
    return ChatState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ChatStates state) {
    if (state is ChatState) {
      return state.toJson();
    }
    return null;
  }

  @override
  Future<void> close() {
    _socketRepository.close();
    return super.close();
  }

  void _connectAndListen() async {
    _socketRepository.connect();

    //When an event recieved from server, data is added to the stream
    _socketRepository.listen('newMessage', (newMessage) {
      final newChat = Chat.fromMap(newMessage);
      add(ChatReceived(chat: newChat));
    });

    _socketRepository.listen('typing', (typingMessage) {
      final User user = typingMessage['user'];
      print('Someone is typing...');
      add(TypingEvent(
        user: user,
        status: TypingStatus.received,
      ));
    });
  }

  FutureOr<void> _onTyping(TypingEvent event, Emitter<ChatStates> emit) {
    final User user = event.user;
    final TypingStatus status = event.status;
    print('I am typing...');
    if (status == TypingStatus.send) {
      _socketRepository.send('typing', {
        'user': user,
      });
    } else {
      emit(TypingState(user: user, isTyping: true));
      _resetOrStartTimer(emit);
    }
  }
}

sealed class ChatEvent {}

final class ChatStarted extends ChatEvent {}

final class TypingState extends ChatStates {
  final bool isTyping;
  final User? user;

  const TypingState({this.user, required this.isTyping});
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

class ChatStates extends Equatable {
  const ChatStates();

  @override
  List<Object?> get props => [];
}

class ChatState extends ChatStates {
  final List<Chat> chats;
  final int unread;

  const ChatState({this.unread = 0, this.chats = const []});

  ChatState copyWith({List<Chat>? chats, int? unread}) {
    return ChatState(
      chats: chats ?? this.chats,
      unread: unread ?? this.unread,
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
