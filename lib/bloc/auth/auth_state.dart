part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

sealed class AuthActionState extends AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final String token;

  AuthSuccess(this.token);
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

final class NavigateToMain extends AuthActionState {}
