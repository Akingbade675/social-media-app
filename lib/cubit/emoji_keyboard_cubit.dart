import 'package:flutter_bloc/flutter_bloc.dart';

class EmojiKeyboardCubit extends Cubit<bool> {
  EmojiKeyboardCubit() : super(false);

  void showKeyboard() => emit(true);

  void hideKeyboard() => emit(false);

  void toggleKeyboard() => emit(!state);

  willPopScope() {
    if (state == true) {
      hideKeyboard();
      return false;
    } else {
      return true;
    }
  }
}
