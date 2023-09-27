import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/data/model/user.dart';
import 'package:social_media_app/data/service/get_all_user_service.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final AuthenticationCubit authenticationCubit;
  UsersCubit({required this.authenticationCubit}) : super(UsersLoading());

  getAllUsers() async {
    emit(UsersLoading());
    final users =
        await GetUserService(token: authenticationCubit.getToken()).call();
    emit(UsersLoaded(users: users));
  }

  getUserById(String id) async {
    emit(UsersLoading());
    final users =
        await GetUserService(token: authenticationCubit.getToken(), userId: id)
            .call();
    emit(UserLoaded(user: users.first));
  }
}
