import 'package:drmohans_homecare_flutter/features/dashboard/data/services/dashboard_service.dart';
import 'package:drmohans_homecare_flutter/utils/location_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final largeTextProvider = StateProvider<String>((ref) {
  return '';
});

final cancelDataListProvider = StateProvider<List<String>>((ref) {
  return [];
});

final cancelRescheduleProvider =
    StateNotifierProvider<CancelRescheduleController, CancelRescheduleStates>(
        (ref) {
  final servcies = ref.watch(dashboardServiceProvider);
  final data = ref.watch(cancelDataListProvider);
  final locationService = ref.watch(locationServiceProvider);
  return CancelRescheduleController(servcies, data, locationService);
});

class CancelRescheduleController extends StateNotifier<CancelRescheduleStates> {
  final DashboardServices services;
  final List<String> dataList;
  final LocationService locationService;
  CancelRescheduleController(this.services, this.dataList, this.locationService)
      : super(CancelRescheduleInitial()) {
    cancelReschedule();
  }

  cancelReschedule() async {
    try {
      final latLong = await locationService.getLatLong();
      final lat = latLong['lat'].toString();
      final long = latLong['long'].toString();
      await services.cancelReschedule(dataList, lat, long);
      state = CancelRescheduleLoaded();
    } catch (e) {
      state = CancelRescheduleError();
    }
  }
}

abstract class CancelRescheduleStates {}

class CancelRescheduleInitial extends CancelRescheduleStates {}

class CancelRescheduleLoaded extends CancelRescheduleStates {}

class CancelRescheduleLoading extends CancelRescheduleStates {}

class CancelRescheduleError extends CancelRescheduleStates {}
