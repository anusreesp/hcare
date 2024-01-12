import 'dart:io';

import 'package:drmohans_homecare_flutter/features/dashboard/data/services/dashboard_service.dart';
import 'package:drmohans_homecare_flutter/features/profile/controller/profile_controller.dart';
import 'package:drmohans_homecare_flutter/features/profile/data/services/profile_services.dart';
import 'package:drmohans_homecare_flutter/features/profile/screens/profile_screen.dart';
import 'package:drmohans_homecare_flutter/utils/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../services/secure_storage_provider.dart';

final punchOutProvider =
    StateNotifierProvider<PunchOutController, PunchOutStates>((ref) {
  final service = ref.watch(dashboardServiceProvider);
  final locationService = ref.watch(locationServiceProvider);
  return PunchOutController(service, locationService, ref);
});

class PunchOutController extends StateNotifier<PunchOutStates> {
  final DashboardServices service;
  final Ref _ref;
  final LocationService locationService;
  PunchOutController(
    this.service,
    this.locationService,
    this._ref,
  ) : super(PunchOutInitial());

  punchOut(context) async {
    try {
      state = PunchOutLoading();
      File? file;
      const storage = FlutterSecureStorage();
      final allValues = await storage.readAll();
      var userId = allValues[StorageKeys.uid];
      var empId = allValues[StorageKeys.empId];
      final latLong = await locationService.getLatLong();
      final lat = latLong['lat'];
      final long = latLong['long'];
      final locationData = await locationService.getLocation(lat, long);
      await service
          .punchInUser(
              file, empId!, userId!, 1, locationData?.address ?? "", lat, long)
          .then((value) {
        _ref.read(isPunchedOut.notifier).state = true;
      });
      print(
          "---------------${_ref.read(isPunchedOut)}----------------------done");
      state = PunchOutSuccess();
    } catch (err) {
      state = PunchOutError();
    }
  }
}

abstract class PunchOutStates {}

class PunchOutInitial extends PunchOutStates {}

class PunchOutLoading extends PunchOutStates {}

class PunchOutSuccess extends PunchOutStates {}

class PunchOutError extends PunchOutStates {}
