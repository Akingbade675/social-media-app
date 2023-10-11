import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media_app/config/app_config.dart';

part 'main_page_state.dart';

class MainPageCubit extends Cubit<BottomNavigationItem> {
  MainPageCubit() : super(BottomNavigationItem.home);

  void tabChange(BottomNavigationItem itemIndex) {
    emit(itemIndex);
  }
}
