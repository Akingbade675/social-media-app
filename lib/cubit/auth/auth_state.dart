part of 'auth_cubit.dart';

@immutable
sealed class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {
  final String? email;
  final String? password;

  AuthenticationInitial({this.email, this.password});

  AuthenticationInitial copyWith({String? email, String? password}) {
    return AuthenticationInitial(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [email, password];
}

final class AuthenticationUnintialized extends AuthenticationState {}

final class AuthenticationAuthenticated extends AuthenticationState {
  final String token;
  final User user;

  AuthenticationAuthenticated({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}

final class AuthenticationUnauthenticated extends AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class AuthenticationFailure extends AuthenticationState {
  final String error;

  AuthenticationFailure(this.error);

  @override
  List<Object?> get props => [error];
}

final class AuthenticationLogout extends AuthenticationState {}
