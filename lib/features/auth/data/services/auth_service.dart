import 'package:dio/dio.dart';
import 'package:drmohans_homecare_flutter/features/auth/data/models/login_model.dart';
import 'package:drmohans_homecare_flutter/utils/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = StateProvider((ref) {
  // final client = ref.watch(dioProvider);
  return AuthService();
});

class AuthService {
  AuthService();
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  Future<LoginModel> userLogin(String username, String password) async {
    try {
      final body = {"UserID": username, "Password": password};
      final response = await dio.post(ApiEndpoints.login, data: body);
      final loginResponse = LoginModel.fromJson(response.data);
      print("res>>>>>>>>>>>>>>>>>>>>>>>>$loginResponse");
      return loginResponse;
    } catch (_) {
      rethrow;
    }
  }
}
