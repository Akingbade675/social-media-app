part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class Login extends AuthEvent {
  final String username;
  final String password;

  Login({required this.username, required this.password});
}

final class Logout extends AuthEvent {}

final class Register extends AuthEvent {
  final String username;
  final String password;

  Register(this.username, this.password);
}

final class CheckAuth extends AuthEvent {
  final String token;

  CheckAuth({required this.token});
}
