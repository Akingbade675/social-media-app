part of 'internet_bloc.dart';

sealed class InternetState extends Equatable {
  const InternetState();

  @override
  List<Object> get props => [];
}

final class InternetLoading extends InternetState {}

final class InternetConnected extends InternetState {}

final class InternetDisconnected extends InternetState {}
