import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/data/service/auth_service.dart';

part 'login_state1.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationCubit authenticationCubit;
  LoginCubit({required this.authenticationCubit}) : super(LoginInitial());

  void setEmail(String email) {
    emit((state as LoginInitial).copyWith(email: email));
  }

  void setPassword(String password) {
    emit((state as LoginInitial).copyWith(password: password));
  }

  void loginUser() async {
    final state = this.state as LoginInitial;
    final username = state.email;
    final password = state.password;
    print('Username: $username. Password: $password');

    emit(LoginLoading());

    try {
      final response = await LoginUserService(username!, password!).call();
      debugPrint(response.user.toString());
      authenticationCubit.loggedIn(token: response.token, user: response.user);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
      emit(LoginInitial());
    }
  }
}
