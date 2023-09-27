part of 'signup_cubit.dart';

@immutable
sealed class SignupState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SignupInitial extends SignupState {
  final String? username;
  final String? email;
  final String? password;
  final String? confirmPassword;

  SignupInitial({
    this.username,
    this.confirmPassword,
    this.email,
    this.password,
  });

  SignupInitial copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? username,
  }) {
    return SignupInitial(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  List<Object?> get props => [email, password, confirmPassword, username];
}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupFailure extends SignupState {
  final String error;

  SignupFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
