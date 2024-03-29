import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:social_media_app/data/model/user.dart';
import 'package:social_media_app/repositories/user_repo.dart';

part 'auth_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final UserRepository userRepository;
  AuthenticationCubit({required this.userRepository})
      : super(AuthenticationUnintialized());

  String getToken() {
    return (state as AuthenticationAuthenticated).token;
  }

  User getUser() {
    return (state as AuthenticationAuthenticated).user;
  }

  void appStarted() async {
    final String token = await userRepository.getToken();
    if (token.isNotEmpty) {
      final User user = await userRepository
          .getUser(); // TODO: Remove this, instead get user from server using the token
      emit(AuthenticationAuthenticated(token: token, user: user));
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  void loggedIn({required String token, required User user}) async {
    await userRepository.persistToken(token);
    await userRepository.persistUser(user); // TODO: Remove this
    emit(AuthenticationAuthenticated(token: token, user: user));
  }

  void loggedOut() async {
    await userRepository.deleteToken();
    emit(AuthenticationUnauthenticated());
  }
}
