part of 'app_cubit.dart';

class AppState extends Equatable {
  final User? user;
  final String? token;
  final List<Chat> chats;

  const AppState({
    this.user,
    this.token,
    this.chats = const [],
  });

  AppState copyWith({User? user, String? token, List<Chat>? chats}) {
    return AppState(
      user: user ?? this.user,
      token: token ?? this.token,
      chats: chats ?? this.chats,
    );
  }

  @override
  List<Object?> get props => [user, token, chats];
}

// final class AppInitial extends AppState {
//   final User? user;
//   final String? token;

//   const AppInitial({this.user, this.token});

//   AppInitial copyWith({User? user, String? token}) {
//     return AppInitial(user: user ?? this.user, token: token ?? this.token);
//   }
// }
