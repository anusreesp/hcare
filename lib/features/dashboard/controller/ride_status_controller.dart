import 'package:drmohans_homecare_flutter/features/collection/controllers/collection_api_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_trip_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/services/dashboard_service.dart';
import 'package:drmohans_homecare_flutter/utils/location_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rideStatusController = StateNotifierProvider.family<RideStatusController,
    RideStatusStates, List<String>>((ref, data) {
  final services = ref.watch(dashboardServiceProvider);
  final locationService = ref.watch(locationServiceProvider);
  final tripId = ref.watch(tripIdProvider);
  return RideStatusController(services, data, locationService, tripId,ref);
});

class RideStatusController extends StateNotifier<RideStatusStates> {
  final DashboardServices _services;
  final List<String> orderData;
  final LocationService locationService;
  final String tripId;
  final Ref ref;
  RideStatusController(
      this._services, this.orderData, this.locationService, this.tripId, this.ref)
      : super(RideStatusInitial()) {
    changeRideStatus();
  }

  Future<void> changeRideStatus() async {
    try {
      state = RideStatusLoading();
      final latLong = await locationService.getLatLong();
      final lat = latLong['lat'];
      final long = latLong['long'];
      final locationData = await locationService.getLocation(lat, long);
      print("lat:$lat, long:$long");
      final dist = ref.watch(rideDistanceProvider);
      _services.rideStatus(orderData, lat.toString(), long.toString(), tripId,locationData?.address,dist.toString());
      state = RideStatusLoaded();
    } catch (e) {
      state = RideStatusError();
    }
  }
}

abstract class RideStatusStates {}

class RideStatusInitial extends RideStatusStates {}

class RideStatusLoading extends RideStatusStates {}

class RideStatusLoaded extends RideStatusStates {}

class RideStatusError extends RideStatusStates {}
