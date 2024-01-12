import 'package:drmohans_homecare_flutter/features/profile/data/models/profile_model.dart';
import 'package:drmohans_homecare_flutter/features/profile/data/services/profile_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider =
    StateNotifierProvider.autoDispose<ProfileController, ProfileStates>((ref) {
  final service = ref.watch(profileServiceProvider);
  return ProfileController(service);
});

final isPunchedIn = StateProvider((ref) => false);
final isPunchedOut = StateProvider((ref) => false);

class ProfileController extends StateNotifier<ProfileStates> {
  final ProfileServices service;
  ProfileController(this.service) : super(ProfileInitial()) {
    getProfile();
  }

  getProfile() async {
    try {
      state = ProfileLoading();
      final res = await service.getProfile();
      print(":::::::::::::::::::${res.toJson()}");
      state = ProfileSuccess(res);
    } catch (_) {
      state = ProfileError();
    }
  }
}

abstract class ProfileStates {}

class ProfileLoading extends ProfileStates {}

class ProfileSuccess extends ProfileStates {
  final ProfileModel profileData;
  ProfileSuccess(this.profileData);
}

class ProfileInitial extends ProfileStates {}

class ProfileError extends ProfileStates {}
