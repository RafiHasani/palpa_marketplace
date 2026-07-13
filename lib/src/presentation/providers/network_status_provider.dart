import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/legacy.dart';

final networkStatusProvider =
    StateNotifierProvider<NetworkStatusProvider, bool>((ref) {
      // Function refreshToken = ref.watch(authProvider.notifier).refreshToken;
      return NetworkStatusProvider();
    });

class NetworkStatusProvider extends StateNotifier<bool> {
  final Connectivity _connectivity = Connectivity();
  // Function _refreshToken = () {};

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  NetworkStatusProvider() : super(false) {
    _checkInitialStatus();
    // _refreshToken = refreshToken;

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      event,
    ) {
      Future.microtask(() => _updateConnectionStatus(event.last));
    });
  }

  Future<void> _checkInitialStatus() async {
    await Future.delayed(Duration(seconds: 3));
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result.last);
  }

  void setState(bool value) {
    state = value;
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      try {
        final result = await InternetAddress.lookup(
          'google.com',
        ).timeout(const Duration(seconds: 2)); // Prevent UI block
        final hasConnection =
            result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        if (hasConnection) {
          state = true;
          // _refreshToken();
        } else {
          state = false;
        }
      } on SocketException catch (_) {
        state = false;
      } on TimeoutException {
        state = false;
      }
    } else {
      state = false;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
