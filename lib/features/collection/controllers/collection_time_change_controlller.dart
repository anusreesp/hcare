import 'package:drmohans_homecare_flutter/common/controller/time_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/services/dashboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updatedTimeController = StateNotifierProvider.family<TimeUpdateController,
    TimeUpdateStates, String>((ref, orderId) {
  final service = ref.watch(dashboardServiceProvider);
  final updateTime = ref.watch(collectionTimeProvider);

  return TimeUpdateController(service, orderId, updateTime);
});

class TimeUpdateController extends StateNotifier<TimeUpdateStates> {
  final DashboardServices service;
  final String orderId;
  final String updateTime;

  TimeUpdateController(this.service, this.orderId, this.updateTime)
      : super(TimeUpdateInitial()) {
    updateCollectionTime();
  }

  updateCollectionTime() async {
    try {
      state = TimeUpdateLoading();

      final updatedTime = service.collectionTimeUpdate(orderId, updateTime);

      state = TimeUpdateLoaded();
    } catch (e) {
      state = TimeUpdateError();
    }
  }
}

abstract class TimeUpdateStates {}

class TimeUpdateLoading extends TimeUpdateStates {}

class TimeUpdateInitial extends TimeUpdateStates {}

class TimeUpdateLoaded extends TimeUpdateStates {}

class TimeUpdateError extends TimeUpdateStates {}
