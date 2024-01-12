import 'dart:developer';

import 'package:drmohans_homecare_flutter/features/collection/data/services/collection_services.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_trip_controller.dart';
import 'package:drmohans_homecare_flutter/utils/location_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

import '../../../services/secure_storage_provider.dart';

final collectionApiStateProvider =
    StateNotifierProvider<CollectionStepNotifier, CollectionStepState>((ref) {
  final collectionService = ref.watch(collectionServiceProvider);
  const storage = FlutterSecureStorage();
  final tripId = ref.watch(tripIdProvider);
  return CollectionStepNotifier(collectionService, storage, tripId, ref);
});

final rideDistanceProvider = StateProvider<int>((ref) => 0);

class CollectionStepNotifier extends StateNotifier<CollectionStepState> {
  final CollectionServices collectionServices;
  final FlutterSecureStorage storage;
  final String tripId;
  final Ref ref;
  CollectionStepNotifier(
      this.collectionServices, this.storage, this.tripId, this.ref)
      : super(CollectionStepInitial());

  Future<List> getDistance(String destLat, String destLong) async {
    try {
      final latLong = await ref.read(locationServiceProvider).getLatLong();
      final lat = latLong['lat'];
      final long = latLong['long'];
      double parsedLat = double.parse(destLat);
      double parsedLong = double.parse(destLong);
      final distance =
          Geolocator.distanceBetween(lat, long, parsedLat, parsedLong);
      double km = distance / 1000;
      double time = km / (40 / 60);
      ref.read(rideDistanceProvider.notifier).state = km.round();

      final data = [km.round(), time.toInt()];
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> vitalMesurementSubmit({
    required String bPSys,
    required String bpDia,
    required final String wt,
    required final String ht,
    required final String orderId,
  }) async {
    final htInMtr = double.parse(ht) / 100;
    final bmi = double.parse(wt) / (htInMtr * htInMtr);
    try {
      final allValues = await storage.readAll();
      final userId = allValues[StorageKeys.uid];
      final empId = allValues[StorageKeys.empId];
      final data = {
        "UserID": userId,
        "EmpID": empId,
        "OrderID": orderId,
        "TripID": tripId,
        "BPSys": bPSys,
        "BPDia": bpDia,
        "Wt": wt,
        "Ht": (htInMtr * 100).toString(),
        "BMI": bmi.toString()
      };
      log(data.toString());
      final result = await collectionServices.vitalInsert(data);
      state = CollectionStepInitial();
      return result;
    } catch (e) {
      state = CollectionStepError(errMsg: e.toString());
    }
  }

  Future<void> getQuestions(
      {required String orderId, required String hcType}) async {
    try {
      final allValues = await storage.readAll();
      final userId = allValues[StorageKeys.uid];
      final empId = allValues[StorageKeys.empId];
      final data = {
        "UserID": userId,
        "EmpID": empId,
        "OrderID": orderId,
        "HCType": hcType
      };
      final questionData = await collectionServices.getQuestionList(data);
      log(questionData.toJson().toString());
      state = CollectionStepData(questionData);
    } catch (e) {
      state = CollectionStepError(errMsg: e.toString());
    }
  }

  Future<dynamic> submitAnswer(
      List<Map<String, dynamic>> answers, String orderId) async {
    try {
      final allValues = await storage.readAll();
      final userId = allValues[StorageKeys.uid];
      final empId = allValues[StorageKeys.empId];
      final data = {
        "UserID": userId,
        "EmpID": empId,
        "OrderID": orderId,
        "HCAns": answers
      };
      return await collectionServices.submitAnswer(data);
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> serviceUpdate({
    required List<Map<String, String>> dataList,
    required String orderId,
  }) async {
    final allValues = await storage.readAll();
    final userId = allValues[StorageKeys.uid];
    final empId = allValues[StorageKeys.empId];
    final data = {
      "UserID": userId,
      "EmpID": empId,
      "OrderID": orderId,
      "TripID": tripId,
      "list": dataList
    };
    log(data.toString());
    try {
      final response = await collectionServices.serviceUpdate(data);
      return response;
    } catch (e) {
      return e.toString();
    }
  }
}

abstract class CollectionStepState {}

class CollectionStepInitial extends CollectionStepState {}

class CollectionStepScreenLoading extends CollectionStepState {}

class CollectionStepData extends CollectionStepState {
  dynamic data;
  CollectionStepData(this.data);
}

class CollectionStepError extends CollectionStepState {
  final String errMsg;
  CollectionStepError({required this.errMsg});
}

final buttonLoadingController = StateProvider<bool>((ref) => false);
