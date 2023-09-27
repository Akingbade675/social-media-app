part of 'main_page_cubit.dart';

sealed class MainPageState extends Equatable {
  const MainPageState();

  @override
  List<Object> get props => [];
}

final class MainPageInitial extends MainPageState {
  final int currentIndex;

  const MainPageInitial({required this.currentIndex});

  @override
  List<Object> get props => [currentIndex];
}

final class MainPageHideBottomBar extends MainPageState {}

final class MainPageShowBottomBar extends MainPageState {}
