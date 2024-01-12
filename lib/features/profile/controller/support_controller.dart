import 'package:drmohans_homecare_flutter/features/profile/data/models/support_model.dart';
import 'package:drmohans_homecare_flutter/features/profile/data/services/profile_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supportDetailsProvider =
    StateNotifierProvider<SupportController, SupportStates>((ref) {
  final services = ref.watch(profileServiceProvider);
  return SupportController(services);
});

class SupportController extends StateNotifier<SupportStates> {
  final ProfileServices services;
  SupportController(this.services) : super(SupportInitial()) {
    getSupportDetails();
  }

  getSupportDetails() async {
    try {
      state = SupportLoading();
      final response = await services.getSupportDetails();
      state = SupportLoaded(response);
    } catch (e) {
      state = SupportError();
    }
  }
}

abstract class SupportStates {}

class SupportInitial extends SupportStates {}

class SupportLoading extends SupportStates {}

class SupportLoaded extends SupportStates {
  final SupportModel data;
  SupportLoaded(this.data);
}

class SupportError extends SupportStates {}
