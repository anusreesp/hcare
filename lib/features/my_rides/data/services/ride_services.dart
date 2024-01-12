import 'package:drmohans_homecare_flutter/features/my_rides/data/models/rides_model/rides_model.dart';
import 'package:drmohans_homecare_flutter/network/network_service.dart';
import 'package:drmohans_homecare_flutter/utils/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rideServiceProvider = StateProvider((ref) {
  final client = ref.watch(dioProvider);
  return RideServices(client);
});

class RideServices {
  final NetworkClient _client;

  RideServices(this._client);

  Future<RidesModel> getRides(dynamic data) async {
    try {
      final response = await _client.postRequest(ApiEndpoints.rideLists, data);
      final RidesModel model = RidesModel.fromJson(response);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
