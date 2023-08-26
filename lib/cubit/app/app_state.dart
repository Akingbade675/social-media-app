part of 'app_cubit.dart';

class AppState {
  final User? user;
  final String? token;

  const AppState({this.user, this.token});

  AppState copyWith({User? user, String? token}) {
    return AppState(user: user ?? this.user, token: token ?? this.token);
  }

  // @override
  // List<Object> get props => [user?.id!, token!];
}

// final class AppInitial extends AppState {
//   final User? user;
//   final String? token;

//   const AppInitial({this.user, this.token});

//   AppInitial copyWith({User? user, String? token}) {
//     return AppInitial(user: user ?? this.user, token: token ?? this.token);
//   }
// }
