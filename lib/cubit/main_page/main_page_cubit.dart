import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_page_state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(const MainPageInitial(currentIndex: 0));

  void tabChange(int index) {
    emit(MainPageInitial(currentIndex: index));
  }

  void hideBottomNavBar() {
    emit(const MainPageInitial(currentIndex: -1));
  }

  void showBottomNavBar() {
    emit(const MainPageInitial(currentIndex: 0));
  }
}
