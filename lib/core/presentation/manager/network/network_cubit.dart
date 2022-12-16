import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_lab/core/common/manager.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> implements Manager {
  NetworkCubit() : super(NetworkInitial());

  final _connectivity = Connectivity();
  bool? _wasOnline;

  Future<void> update() async {
    final result = await _connectivity.checkConnectivity();

    final isConnected = await _isOnline(result);
    _shouldEmit(isConnected);

    _connectivity.onConnectivityChanged.listen((event) async {
      final isOnline = await _isOnline(event);
      _shouldEmit(isOnline);
    });
  }

  void _shouldEmit(bool isOnline) {
    if (isOnline != _wasOnline) {
      emit(NetworkChanged(connected: isOnline));
      _wasOnline = isOnline;
    }
  }

  Future<bool> _isOnline(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      return false;
    }

    return _checkConnection();
  }

  Future<bool> _checkConnection() async {
    var isOnline = false;

    try {
      final result = await InternetAddress.lookup('ecosia.org');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }

    return isOnline;
  }
}
