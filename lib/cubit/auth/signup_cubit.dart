import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:social_media_app/data/service/signup_user_service.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  void setEmail(String email) {
    emit((state as SignupInitial).copyWith(email: email));
  }

  void setPassword(String password) {
    emit((state as SignupInitial).copyWith(password: password));
  }

  void setConfirmPassword(String confirmPassword) {
    emit((state as SignupInitial).copyWith(confirmPassword: confirmPassword));
  }

  void setUsername(String username) {
    emit((state as SignupInitial).copyWith(username: username));
  }

  void signupUser() async {
    final state = this.state as SignupInitial;
    final email = state.email;
    final password = state.password;
    final confirmPassword = state.confirmPassword;
    final username = state.username;
    print('Username: $username. Password: $password');

    if (password != confirmPassword) {
      emit(SignupFailure(error: 'Password does not match'));
      return;
    }

    emit(SignupLoading());

    try {
      await SignupUserService(
        username: username!,
        password: password!,
        email: email!,
      ).call();
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(error: e.toString()));
    }
  }
}
