import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_trip_controller.dart';
import 'package:drmohans_homecare_flutter/features/delivery/services/delivery_services.dart';
import 'package:drmohans_homecare_flutter/utils/location_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deliveryItemPickedController = StateNotifierProvider.family<
    DeliveryItemPickedController,
    DeliveryItemStates,
    List<String>>((ref, data) {
  final service = ref.watch(deliveryServiceProvider);
  final tripId = ref.watch(tripIdProvider);
  final locationService = ref.watch(locationServiceProvider);
  return DeliveryItemPickedController(service, data, tripId, locationService);
});

class DeliveryItemPickedController extends StateNotifier<DeliveryItemStates> {
  final DeliveryServices services;
  final List<String> orderDetails;
  final String tripId;
  final LocationService locationService;
  DeliveryItemPickedController(
      this.services, this.orderDetails, this.tripId, this.locationService)
      : super(DeliveryItemPickInitial()) {
    updatePickStatus();
  }

  updatePickStatus() async {
    try {
      state = DeliveryItemPickLoading();
      final latLong = await locationService.getLatLong();
      final lat = latLong['lat'].toString();
      final long = latLong['long'].toString();
      // final locationData = await locationService.getLocation(lat, long);
      await services.itemPickedStatus(
          orderDetails[0], orderDetails[1], lat, long, orderDetails[2], tripId);
      state = DeliveryItemPickSuccess();
    } catch (e) {
      state = DeliveryItemPickError();
    }
  }
}

abstract class DeliveryItemStates {}

class DeliveryItemPickLoading extends DeliveryItemStates {}

class DeliveryItemPickSuccess extends DeliveryItemStates {}

class DeliveryItemPickInitial extends DeliveryItemStates {}

class DeliveryItemPickError extends DeliveryItemStates {}
