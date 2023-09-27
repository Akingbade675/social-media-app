part of 'users_cubit.dart';

sealed class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  const UsersLoaded({this.users = const []});

  final List<User> users;

  UsersLoaded copyWith({required List<User> users}) {
    return UsersLoaded(users: users);
  }

  @override
  List<Object> get props => [users];
}

class UserLoaded extends UsersState {
  final User user;

  const UserLoaded({required this.user});

  UserLoaded copyWith({required User user}) {
    return UserLoaded(user: user);
  }

  @override
  List<Object> get props => [user];
}
