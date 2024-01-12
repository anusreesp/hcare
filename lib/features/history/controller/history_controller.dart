import 'dart:developer';

import 'package:drmohans_homecare_flutter/features/history/data/models/history_model.dart';
import 'package:drmohans_homecare_flutter/features/history/data/services/history_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../services/secure_storage_provider.dart';

final isRideComplete = StateProvider.autoDispose<bool>((ref) => false);

final historyProvider =
    StateNotifierProvider<HistoryController, HistoryState>((ref) {
  final rideServices = ref.watch(historyServiceProvider);
  return HistoryController(rideServices);
});

class HistoryController extends StateNotifier<HistoryState> {
  final HistoryServices historyServices;
  late String? userId;
  late String? empId;
  HistoryController(this.historyServices) : super(HistoryInitial());

  Future<void> getHistoryData({
    required String fromDate,
    required String toDate,
    required String type,
  }) async {
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
      };

      final historyList = await historyServices.getHistory(data);
      log('${historyList.lst.length}');
      state = HistoryData(history: historyList);
    } catch (e) {
      state = HistoryError(error: e.toString());
    }
  }
}

abstract class HistoryState {}

class HistoryInitial implements HistoryState {}

class HistoryLoading implements HistoryState {}

class HistoryData implements HistoryState {
  final History history;

  HistoryData({required this.history});
}

class HistoryError implements HistoryState {
  final String error;

  HistoryError({required this.error});
}
