part of 'authentication_cubit.dart';

@immutable
sealed class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class AuthenticationSuccess extends AuthenticationState {
  final User user;
  final String token;

  AuthenticationSuccess({required this.user, required this.token});

  @override
  List<Object?> get props => [user.id, token];
}

final class AuthenticationFailure extends AuthenticationState {
  final String error;

  AuthenticationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
