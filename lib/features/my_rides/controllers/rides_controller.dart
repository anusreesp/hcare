import 'dart:developer';

import 'package:drmohans_homecare_flutter/features/my_rides/data/models/rides_model/rides_model.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/data/services/ride_services.dart';
import 'package:drmohans_homecare_flutter/services/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final ridesProvider =
    StateNotifierProvider<RidesController, RidesStates>((ref) {
  final rideServices = ref.watch(rideServiceProvider);
  return RidesController(rideServices);
});

class RidesController extends StateNotifier<RidesStates> {
  final RideServices rideServices;
  late String? userId;
  late String? empId;
  RidesController(this.rideServices) : super(RidesInitial());

  Future<void> getRides({
    required String fromDate,
    required String toDate,
    required int hcStatus,
    required String type,
  }) async {
    // state = RidesInitial();
    const storage = FlutterSecureStorage();
    final allValues = await storage.readAll();
    userId = allValues[StorageKeys.uid];
    empId = allValues[StorageKeys.empId];
    try {
      final data = {
        "UserID": userId,
        "EmpID": empId,
        "FromDate": fromDate,
        "ToDate": toDate,
        "HCTYpe": type,
        "HCStatus": hcStatus
      };

      final rideList = await rideServices.getRides(data);
      log('${rideList.rideList.length}');
      state = RidesData(data: rideList);
    } catch (e) {
      state = RidesError(errorMsg: e.toString());
    }
  }
}

abstract class RidesStates {}

class RidesInitial extends RidesStates {}

class RidesLoading extends RidesStates {}

class RidesError extends RidesStates {
  final String errorMsg;

  RidesError({required this.errorMsg});
}

class RidesData extends RidesStates {
  final RidesModel data;
  RidesData({required this.data});
}
