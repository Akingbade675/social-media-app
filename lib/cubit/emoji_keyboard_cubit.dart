import 'package:flutter_bloc/flutter_bloc.dart';

class EmojiKeyboardCubit extends Cubit<bool> {
  EmojiKeyboardCubit() : super(false);

  void showKeyboard() {
    print('show keyboard');
    emit(true);
  }

  void hideKeyboard() {
    print('hide keyboard');
    emit(false);
  }

  void toggleKeyboard() {
    print('toggle keyboard to ${!state}');
    emit(!state);
  }

  willPopScope() {
    if (state) {
      hideKeyboard();
      print('false');
      return false;
    } else {
      print('true');
      return true;
    }
  }
}
