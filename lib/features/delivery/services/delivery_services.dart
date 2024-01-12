import 'package:drmohans_homecare_flutter/network/network_service.dart';
import 'package:drmohans_homecare_flutter/services/secure_storage_provider.dart';
import 'package:drmohans_homecare_flutter/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final deliveryServiceProvider = StateProvider((ref) {
  final client = ref.watch(dioProvider);
  return DeliveryServices(client);
});

class DeliveryServices {
  final NetworkClient client;

  DeliveryServices(this.client);

  Future<void> itemPickedStatus(String orderId, String address, String lat,
      String lng, String status, String tripId) async {
    try {
      const storage = FlutterSecureStorage();
      final allValues = await storage.readAll();
      var userId = allValues[StorageKeys.uid];
      var empId = allValues[StorageKeys.empId];

      final data = {
        "UserID": userId,
        "EmpID": empId,
        "OrderID": orderId,
        "Addr": address,
        "Lat": lat,
        "Lng": lng,
        "Sts": status,
        /* 0 - Item Pick Up , 1 - Reached Warehouse,Item picked */
        "TripID": tripId
      };

      final response =
          await client.postRequest(ApiEndpoints.itemPickedStatus, data);
      debugPrint(">>>>>>>>>>>>>>>>>$data");
      debugPrint(">>>>>>>>>>>>>>>>>$response");
    } catch (e) {
      debugPrint(">>>>>>>>>>>>>>>>>$e");
      rethrow;
    }
  }
}
