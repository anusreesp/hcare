import 'package:drmohans_homecare_flutter/features/history/data/models/history_model.dart';
import 'package:drmohans_homecare_flutter/network/network_service.dart';
import 'package:drmohans_homecare_flutter/utils/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyServiceProvider = StateProvider((ref) {
  final client = ref.watch(dioProvider);
  return HistoryServices(client);
});

class HistoryServices {
  final NetworkClient _client;

  HistoryServices(this._client);

  Future<History> getHistory(dynamic data) async {
    try {
      final response = await _client.postRequest(ApiEndpoints.history, data);
      final History model = History.fromJson(response);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
