import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final internetProvider =
    StateNotifierProvider<InternetController, InternetState>((ref) {
  return InternetController();
});

class InternetController extends StateNotifier<InternetState> {
  static InternetController? _internetController;

  late StreamSubscription connectivityStreamSubscription;
  final Connectivity connectivity = Connectivity();
  Future<void> checkInternet() async {
    connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) async {
      if ((connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi)) {
        state = Connected();
      } else {
        state = NoInternet();
      }
    });
  }

  factory InternetController() {
    _internetController ??= InternetController._internal();
    return _internetController!;
  }

  InternetController._internal() : super(InternetInitial()) {
    checkInternet();
  }
}

abstract class InternetState {}

class InternetInitial extends InternetState {}

class Connected extends InternetState {}

class NoInternet extends InternetState {}
