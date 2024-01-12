import 'package:drmohans_homecare_flutter/features/auth/controller/auth_controller.dart';
import 'package:drmohans_homecare_flutter/features/auth/data/services/auth_service.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/services/dashboard_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../services/secure_storage_provider.dart';

final loginProvider =
    StateNotifierProvider<LoginController, LoginStates>((ref) {
  final authService = ref.watch(authServiceProvider);
  final dashService = ref.watch(dashboardServiceProvider);
  return LoginController(authService: authService, ref: ref, dashService: dashService);
});

class LoginController extends StateNotifier<LoginStates> {
  final AuthService authService;
  final Ref ref;
  final DashboardServices dashService;
  LoginController({required this.authService, required this.ref,required this.dashService})
      : super(LoginInitialState());

  Future<void> login(String username, String password, BuildContext context) async {
    try {
      state = LoginLoadingState();
      final response = await authService.userLogin(username, password);
      if (response.userId != null) {
        const storage = FlutterSecureStorage();
        await storage.write(key: StorageKeys.uid, value: response.userId);
        await storage.write(key: StorageKeys.empId, value: response.empId);
        await storage.write(key: StorageKeys.tokenKey, value: response.token);
        final allValues = await storage.readAll();
        ref.read(authProvider.notifier).changeToLoggedInState(allValues);
        state = LoginSuccessState(allData: allValues);
      } else {
        state = LoginErrorState();
      }
    } catch (err) {
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>:::::::>>>$err");
      state = LoginErrorState();
    }
  }
}

abstract class LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final Map<String, String> allData;
  LoginSuccessState({required this.allData});
}

class LoginErrorState extends LoginStates {}

class LoginInitialState extends LoginStates {}
