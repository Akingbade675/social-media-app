import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:social_media_app/data/service/auth_service.dart';
import 'package:social_media_app/data/model/user.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  void loginUser(String username, String password) async {
    emit(AuthenticationLoading());
    try {
      final response = await LoginUserService(username, password).call();
      debugPrint(response.user.toString());
      emit(AuthenticationSuccess(user: response.user, token: response.token));
    } catch (e) {
      emit(AuthenticationFailure(e.toString()));
    }
  }
}
