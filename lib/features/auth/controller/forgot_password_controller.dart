import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordController extends StateNotifier<ForgotPasswordStates> {
  ForgotPasswordController() : super(ForgotPasswordInitial()) {
    startCounter();
  }
  startCounter() {
    int seconds = 30;
    if (seconds != 0) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        seconds--;
      });
    }
    print(">>>>>>>>>>>>>>>>>>$seconds");
  }
}

abstract class ForgotPasswordStates {}

class ForgotPasswordInitial extends ForgotPasswordStates {}
