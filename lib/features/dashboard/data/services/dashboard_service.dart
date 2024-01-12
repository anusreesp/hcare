import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/models/dashboard_model.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/models/get_order_details_model.dart';
import 'package:drmohans_homecare_flutter/network/network_service.dart';
import 'package:drmohans_homecare_flutter/utils/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../services/secure_storage_provider.dart';

final dashboardServiceProvider = StateProvider((ref) {
  final client = ref.watch(dioProvider);
  return DashboardServices(client);
});

class DashboardServices {
  final NetworkClient client;

  DashboardServices(this.client);

  Future<DashboardModel> getDashboardData(
      {required String fromDate,
      required String toDate,
      required String? userId,
      required String? empId}) async {
    try {
      final body = {
        "UserID": userId,
        "EmpID": empId,
        "FromDate": fromDate,
        "ToDate": toDate,
        "HCTYpe": "All"
      };
      final response = await client.postRequest(ApiEndpoints.dashboard, body);
      debugPrint("-------------------${response['TripStartSts']}");
      final dashboardResponse = DashboardModel.fromJson(response);
      return dashboardResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetOrderDetails> getOrderDetails(String orderId, String type) async {
    try{
      const storage = FlutterSecureStorage();
      final allValues = await storage.readAll();
      var userId = allValues[StorageKeys.uid];
      var empId = allValues[StorageKeys.empId];
      final data = {
        "UserID": userId,
        "EmpID": empId,
        "OrderID": orderId,
        "HCTYpe": type
      };
      final response =
          await client.postRequest(ApiEndpoints.getOrderDetails, data);
      return GetOrderDetails.fromJson(response);
    }catch(e){
      print("--------------------->$e");
      rethrow;
    }
  }

  Future<void> punchInUser(
    File? file,
    String empId,
    String userId,
    int status,
    String address,
    double lat,
    double long,
  ) async {
    try {
      const storage = FlutterSecureStorage();
      final allValues = await storage.readAll();
      var userId = allValues[StorageKeys.uid];
      var empId = allValues[StorageKeys.empId];
      final data = FormData.fromMap({
        'file': file != null
            ? await MultipartFile.fromFile(file.path)
            : MultipartFile.fromBytes(
                List<int>.empty(), // Empty content
                filename: 'empty.txt',
              ),
        'EmpID': empId,
        'UserID': userId,
        'PunchSts': status,
        'Address': address,
        'Lat': lat,
        'Lng': long,
      });
      print(">>>>>>>>>>>>>>>>>//${data.fields}");

      final response =
          await client.postRequest(ApiEndpoints.punchRegister, data);
      print(">>>>>>>>>>>>>>>>>$response");
    } catch (e) {
      print("Errrrrrrrrrrrrrrrr>>$e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> startOrEndRide(
      String userId,
      String empId,
      String address,
      String status,
      String lat,
      String long,
      String? tripId) async {
    try {
      final data = {
        "UserID": userId,
        "EmpID": empId,
        "Addr": address,
        "TripSts": status,
        if (tripId != null) "TripID": tripId,
        "Lat": lat,
        "Lng": long
      };
      print("body---------->>$data");
      final response =
          await client.postRequest(ApiEndpoints.tripRegister, data);
      print(">>>>>>>>>>>$response");
      return response;
    } catch (err) {
      rethrow;
    }
  }

  Future<void> collectionTimeUpdate(String orderId, String updatedTime) async {
    const storage = FlutterSecureStorage();
    final allValues = await storage.readAll();
    var userId = allValues[StorageKeys.uid];
    var empId = allValues[StorageKeys.empId];

    final data = {
      "UserID": userId,
      "EmpID": empId,
      "OrderID": orderId,
      "HCTime": updatedTime
    };
    final response = await client.postRequest(ApiEndpoints.timeUpdate, data);
    debugPrint(">>>>>>>>>>>>>>>>>$response");
  }

  Future<void> rideStatus(List<String> dataList, String lat, String lng,
      String tripId, String? address,String? rideKM) async {
    const storage = FlutterSecureStorage();
    final allValues = await storage.readAll();
    var userId = allValues[StorageKeys.uid];
    var empId = allValues[StorageKeys.empId];

    final data = {
      "UserID": userId,
      "EmpID": empId,
      "OrderID": dataList[0],
      "Addr": address,
      "Lat": lat,
      "Lng": lng,
      "Sts": dataList[2],
      /* 0 - Start Ride , 1 - End2 Ride , 2 - Reached Location */
      "TripID": tripId,
      "RideKm":rideKM,
    };

    debugPrint(">>>>>>>rideStatus>>>>${address}");

    final response = await client.postRequest(ApiEndpoints.rideStatus, data);
    print(">>>>>>>rideStatus>>>>$response");
  }

  Future<void> cancelReschedule(
      List<String> dataList, String lat, String lng) async {
    const storage = FlutterSecureStorage();
    final allValues = await storage.readAll();
    var userId = allValues[StorageKeys.uid];
    var empId = allValues[StorageKeys.empId];

    try {
      final data = {
        "UserID": userId,
        "EmpID": empId,
        "OrderID": dataList[0],
        "Addr": dataList[1],
        "Lat": lat,
        "Lng": lng,
        // "Addr": "Bangalore",
        // "Lat": "12.925740130496504",
        // "Lng": "80.12818699667869",
        "Sts": dataList[2],
        /* 3 - Rescheduled , 5 - Cancelled*/
        "TripID": dataList[3],
        "Reason": dataList[4]
      };
      final response =
          await client.postRequest(ApiEndpoints.cancelReschedule, data);
      print(">>>>>>>>>>>$response");
    } catch (e) {
      debugPrint("-----------------$e");
      rethrow;
    }
  }

  Future saveDeviceId(String fcmToken) async {
    try {
      const storage = FlutterSecureStorage();
      final allValues = await storage.readAll();
      var userId = allValues[StorageKeys.uid];
      var empId = allValues[StorageKeys.empId];
      final data = {"UserID": userId, "EmpID": empId, "DeviceID": fcmToken};
      print("---------------------------->dtoken>>>>>$data");
      final response =
          await client.postRequest(ApiEndpoints.saveDeviceId, data);
      print("---------------------------->rtoken>>>>>$response");
    } catch (err) {
      print("err------------------>$err");
      rethrow;
    }
  }

  Future versionUpdate(String version, String platform, userId) async {
    try {
      final data = {"Version": version, "Device": platform, "UserID": userId};
      final response = await client.postRequestWithoutToken(
          ApiEndpoints.versionUpdate, data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
