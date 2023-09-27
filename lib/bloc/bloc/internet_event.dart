part of 'internet_bloc.dart';

sealed class InternetEvent extends Equatable {
  const InternetEvent();

  @override
  List<Object> get props => [];
}

final class EmitInternetConnected extends InternetEvent {}

final class EmitInternetDisconnected extends InternetEvent {}
