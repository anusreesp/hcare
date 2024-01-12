import 'package:drmohans_homecare_flutter/features/collection/data/models/question_list_model/question_list_model.dart';
import 'package:drmohans_homecare_flutter/network/network_service.dart';
import 'package:drmohans_homecare_flutter/utils/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final collectionServiceProvider = Provider((ref) {
  final client = ref.watch(dioProvider);
  return CollectionServices(client);
});

class CollectionServices {
  final NetworkClient _client;

  CollectionServices(this._client);

  Future<dynamic> vitalInsert(dynamic data) async {
    try {
      return await _client.postRequest(ApiEndpoints.vitalInsert, data);
    } catch (e) {
      rethrow;
    }
  }

  Future<QuestionListModel> getQuestionList(dynamic data) async {
    try {
      final response =
          await _client.postRequest(ApiEndpoints.getQuestionList, data);
      return QuestionListModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitAnswer(dynamic data) async {
    try {
      return await _client.postRequest(ApiEndpoints.submitAnswer, data);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> serviceUpdate(dynamic data) async {
    try {
      return await _client.postRequest(ApiEndpoints.serviceUpdate, data);
    } catch (e) {
      rethrow;
    }
  }
}
