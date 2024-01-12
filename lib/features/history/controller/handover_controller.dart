import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_trip_controller.dart';
import 'package:drmohans_homecare_flutter/features/history/data/models/handover_models.dart';
import 'package:drmohans_homecare_flutter/features/history/data/services/handover_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final handOverDetailsProvider =
    StateNotifierProvider<HandOverDetails, HandOverStates>((ref) {
  final tripId = ref.watch(tripIdProvider);
  final services = ref.watch(handOverServicesProvider);
  return HandOverDetails(services, tripId);
});

class HandOverDetails extends StateNotifier<HandOverStates> {
  final HandOverDetailsServices services;
  final String tripId;
  HandOverDetails(this.services, this.tripId) : super(HandOverInitial()) {
    getHandOverDetails();
  }

  getHandOverDetails() async {
    try {
      state = HandOverLoading();
      final response = await services.getHandOverDetails(tripId);
      state = HandOverLoaded(response);
    } catch (e) {
      state = HandOverError(e.toString());
    }
  }
}

abstract class HandOverStates {}

class HandOverInitial extends HandOverStates {}

class HandOverLoading extends HandOverStates {}

class HandOverLoaded extends HandOverStates {
  final HandOverDetailsModel response;
  HandOverLoaded(this.response);
}

class HandOverError extends HandOverStates {
  final String error;
  HandOverError(this.error);
}
