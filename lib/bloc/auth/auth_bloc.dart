import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<Login>(_login);
  }

  FutureOr<void> _login(Login event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      debugPrint('Login: ${event.username} - ${event.password}');
      await Future.delayed(const Duration(seconds: 2));
      emit(NavigateToMain());
      emit(AuthSuccess('token'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
