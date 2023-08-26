import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media_app/data/model/user.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void userLoggedIn({required User user, required String token}) {
    emit(state.copyWith(user: user, token: token));
  }
}
