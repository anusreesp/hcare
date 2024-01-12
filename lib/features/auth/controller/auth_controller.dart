import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/services/auth_service.dart';

final authProvider = StateNotifierProvider((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthController(authService: authService, ref: ref);
});

class AuthController extends StateNotifier<AuthStates> {
  final AuthService authService;
  final Ref ref;
  AuthController({required this.authService, required this.ref})
      : super(AuthInitial()) {
    init();
  }

  init() async {
    const storage = FlutterSecureStorage();
    final allValues = await storage.readAll();
    if (allValues.isNotEmpty) {
      state = LoggedInState(allData: allValues);
    } else {
      state = LoggedOutState();
    }
  }

  changeToLoggedInState(Map<String, String> allData) {
    state = LoggedInState(allData: allData);
  }

  Future<void> logout() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
    state = LoggedOutState();
  }
}

abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class LoggedInState extends AuthStates {
  final Map<String, String> allData;
  LoggedInState({required this.allData});
}

class LoginLoadingState extends AuthStates {}

class LoggedOutState extends AuthStates {}

class LoggedInErrorState extends AuthStates {}
