import 'package:dio/dio.dart';
import 'package:drmohans_homecare_flutter/services/secure_storage_provider.dart';
import 'package:drmohans_homecare_flutter/utils/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'custom_exception.dart';

final dioProvider = Provider((ref) {
  final config = ref.watch(flutterStorageProvider);
  return NetworkClient(
    token: config[StorageKeys.tokenKey],
  );
});

class NetworkClient {
  final String? token;
  late final Dio _dio;
  NetworkClient({this.token}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
      ),
    );
  }

  Future<dynamic> postRequest(String path, dynamic data) async {
    _dio.options.headers = {
      "Content-Type": "application/json",
      "authorization": "Bearer $token"
    };
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw CustomException.fromDioError(e);
    }
  }

  Future<Response> postRequestWithoutToken(String path, dynamic data) async {
    _dio.options.headers = {
      "Content-Type": "application/json",
    };
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw CustomException.fromDioError(e);
    }
  }

  Future<dynamic> getRequest(String path) async {
    _dio.options.headers = {
      "Content-Type": "application/json",
      "authorization": "Bearer $token"
    };
    try {
      final response = await _dio.get(path);
      return response.data;
    } on DioException catch (e) {
      throw CustomException.fromDioError(e);
    }
  }

  Future<dynamic> getRequestWithoutToken(String path) async {
    _dio.options.headers = {
      "Content-Type": "application/json",
    };
    try {
      final response = await _dio.get(path);
      return response.data;
    } on DioException catch (e) {
      throw CustomException.fromDioError(e);
    }
  }
}
