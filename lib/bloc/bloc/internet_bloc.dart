import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity connectivity;
  StreamSubscription? connectivitySubscription;

  InternetBloc({required this.connectivity}) : super(InternetLoading()) {
    monitorInternetConnection();

    on<EmitInternetConnected>((event, emit) {
      emit(InternetConnected());
    });

    on<EmitInternetDisconnected>((event, emit) {
      emit(InternetDisconnected());
    });
  }

  StreamSubscription<ConnectivityResult> monitorInternetConnection() {
    return connectivitySubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.wifi) {
        add(EmitInternetConnected());
      } else if (connectivityResult == ConnectivityResult.mobile) {
        add(EmitInternetConnected());
      } else if (connectivityResult == ConnectivityResult.none) {
        add(EmitInternetDisconnected());
      }
    });
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}
