import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/data/model/chat.dart';
import 'package:social_media_app/data/service/create_message_service.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final AuthenticationCubit authenticationCubit;
  MessageCubit({required this.authenticationCubit}) : super(MessageInitial());

  void sendMessage(String message) async {
    if (message.isEmpty) return;

    emit(MessageLoading());

    try {
      await CreateMessageService(
        message: message,
        token: authenticationCubit.getToken(),
      ).call();
      log('Message Sent Successfully');
      emit(MessageSent());
    } catch (e) {
      emit(MessageFailure(error: e.toString()));
    }
  }
}
