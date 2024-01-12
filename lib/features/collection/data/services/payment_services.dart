import 'package:drmohans_homecare_flutter/network/network_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/api_endpoints.dart';

final paymentServiceProvider = Provider<PaymentServices>((ref) {
  final client = ref.watch(dioProvider);
  return PaymentServices(client: client);
});

class PaymentServices {
  final NetworkClient _client;

  PaymentServices({required NetworkClient client}) : _client = client;
  Future<dynamic> paymet(dynamic data) async {
    try {
      return await _client.postRequest(ApiEndpoints.paymentUpdate, data);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> sendRazorpayLink(dynamic data) async {
    try {
      return await _client.postRequest(ApiEndpoints.sendRazorpayLink, data);
    } catch (e) {
      rethrow;
    }
  }
}
