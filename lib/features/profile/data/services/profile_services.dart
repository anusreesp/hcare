import 'package:drmohans_homecare_flutter/features/profile/data/models/notifications_model.dart';
import 'package:drmohans_homecare_flutter/features/profile/data/models/profile_model.dart';
import 'package:drmohans_homecare_flutter/features/profile/data/models/support_model.dart';
import 'package:drmohans_homecare_flutter/network/network_service.dart';
import 'package:drmohans_homecare_flutter/services/secure_storage_provider.dart';
import 'package:drmohans_homecare_flutter/utils/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final profileServiceProvider = StateProvider((ref) {
  final client = ref.watch(dioProvider);
  return ProfileServices(client);
});

class ProfileServices {
  final NetworkClient client;
  ProfileServices(this.client);

  Future<ProfileModel> getProfile() async {
    const storage = FlutterSecureStorage();
    final allValues = await storage.readAll();
    var userId = allValues[StorageKeys.uid];
    var empId = allValues[StorageKeys.empId];
    final body = {"UserID": userId, "EmpID": empId};
    final response = await client.postRequest(ApiEndpoints.userDetails, body);
    return ProfileModel.fromJson(response);
  }

  Future<GetNotificationsModel> getNotifications(
      String userId, String empId) async {
    try {
      final data = {
        "UserID": userId,
        "EmpID": empId,
      };
      final response =
          await client.postRequest(ApiEndpoints.notificationList, data);
      return GetNotificationsModel.fromJson(response);
    } catch (err) {
      rethrow;
    }
  }

  Future<SupportModel> getSupportDetails() async {
    const storage = FlutterSecureStorage();
    final allValues = await storage.readAll();
    var userId = allValues[StorageKeys.uid];
    var empId = allValues[StorageKeys.empId];

    final data = {
      "UserID": userId,
      "EmpID": empId,
    };

    final response =
        await client.postRequest(ApiEndpoints.getSupportDetails, data);
    return SupportModel.fromJson(response);
  }
}
