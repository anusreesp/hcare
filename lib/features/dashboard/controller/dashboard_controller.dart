import 'dart:io';

import 'package:drmohans_homecare_flutter/features/dashboard/data/models/dashboard_model.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/services/dashboard_service.dart';
import 'package:drmohans_homecare_flutter/services/secure_storage_provider.dart';
import 'package:drmohans_homecare_flutter/utils/helper_fuctions/helper.dart';
import 'package:drmohans_homecare_flutter/utils/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'home_filter_controller.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardController, DashboardStates>((
  ref,
) {
  final services = ref.watch(dashboardServiceProvider);
  final locationService = ref.watch(locationServiceProvider);
  return DashboardController(services, locationService, ref);
});

final isButtonLoading = StateProvider<bool>((ref) => false);

class DashboardController extends StateNotifier<DashboardStates>
    with HelperFunctions {
  final DashboardServices _services;
  final LocationService locationService;
  final Ref _ref;
  late String? userId;
  late String? empId;
  DashboardController(this._services, this.locationService, this._ref)
      : super(DashboardInitial());
  // {
  //   init();
  // }

  init({
    required String fromDate,
    required String toDate,
  }) async {
    const storage = FlutterSecureStorage();
    final allValues = await storage.readAll();
    userId = allValues[StorageKeys.uid];
    empId = allValues[StorageKeys.empId];
    try {
      // state = DashboardLoading();
      final dashboardData = await _services.getDashboardData(
          fromDate: fromDate, toDate: toDate, userId: userId, empId: empId);
      debugPrint("-------------------${dashboardData.tripStartSts}");

      state = DashboardLoaded(dashboardData);
    } catch (e) {
      state = DashboardError(e.toString());
    }
  }

  Future<String?> punchIn(
    File file,
  ) async {
    try {
      state = PunchInLoading();
      const storage = FlutterSecureStorage();
      final allValues = await storage.readAll();
      userId = allValues[StorageKeys.uid];
      empId = allValues[StorageKeys.empId];
      final latLong = await locationService.getLatLong();
      final filterType = _ref.watch(homeFilterProvider);
      final selectedDate = getFromAndToDate(filterType);
      print(">>>>>>>>>>>>>>>>>>>:$latLong");
      final lat = latLong['lat'];
      final long = latLong['long'];
      final locationData = await locationService.getLocation(lat, long);
      print(">>>>>>>>>>>>>>>>>>>:::${locationData?.address}");
      await _services.punchInUser(
          file, empId!, userId!, 0, locationData?.address ?? "", lat, long);
      await init(
          fromDate: selectedDate["FromDate"]!, toDate: selectedDate['ToDate']!);
      return locationData?.address;
    } catch (e) {
      print(">>>>>>>>>>>>>>>>>>><:::$e");
      state = PunchInError();
    }
    return null;
  }
}

abstract class DashboardStates {}

class DashboardInitial extends DashboardStates {}

class DashboardLoading extends DashboardStates {}

class DashboardLoaded extends DashboardStates {
  final DashboardModel dashboardData;
  DashboardLoaded(this.dashboardData);
}

class DashboardError extends DashboardStates {
  final String error;
  DashboardError(this.error);
}

class PunchInLoading extends DashboardStates {}

class PunchInError extends DashboardStates {}
