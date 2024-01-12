import 'package:drmohans_homecare_flutter/features/history/data/models/handover_models.dart';
import 'package:drmohans_homecare_flutter/network/network_service.dart';
import 'package:drmohans_homecare_flutter/services/secure_storage_provider.dart';
import 'package:drmohans_homecare_flutter/utils/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final handOverServicesProvider = StateProvider((ref) {
  final client = ref.watch(dioProvider);
  return HandOverDetailsServices(client);
});

class HandOverDetailsServices {
  final NetworkClient client;
  HandOverDetailsServices(this.client);

  Future<HandOverDetailsModel> getHandOverDetails(String tripId) async {
    const storage = FlutterSecureStorage();
    final allValues = await storage.readAll();
    var userId = allValues[StorageKeys.uid];
    var empId = allValues[StorageKeys.empId];
    try {
      final body = {"UserID": userId, "EmpID": empId, "TripID": tripId};
      final response = await client.postRequest(ApiEndpoints.getHandOver, body);

      return HandOverDetailsModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
