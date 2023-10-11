import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media_app/bloc/bloc/internet_bloc.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/data/model/user.dart';
import 'package:social_media_app/data/service/get_all_user_service.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final AuthenticationCubit authenticationCubit;
  UsersCubit({required this.authenticationCubit}) : super(UsersLoading());

  getAllUsers(InternetState internetState) async {
    // check if users have been loaded before
    emit(UsersLoading());
    try {
      final users =
          await GetUserService(token: authenticationCubit.getToken()).call();
      emit(UsersLoaded(users: users));
    } on Exception catch (e) {
      print(e);
    }
  }

  getUserById(String id) async {
    emit(UsersLoading());
    final users =
        await GetUserService(token: authenticationCubit.getToken(), userId: id)
            .call();
    emit(UserLoaded(user: users.first));
  }
}
