import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_trip_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/services/dashboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../services/secure_storage_provider.dart';

final tripStatusProvider = StateNotifierProvider<TripStatusController,TripStatusStates>((ref){
  final service = ref.watch(dashboardServiceProvider);
  return TripStatusController(service,ref);
});

final tripLoadingProvider = StateProvider<bool>((ref) => false);

class TripStatusController extends StateNotifier<TripStatusStates>{
  final DashboardServices service;
  final Ref ref;
  TripStatusController(this.service, this.ref) : super(TripStatusInitial());

   Future<void> startOrEndTrip(String address,String status,String lat,String long, String? tripId)async{
    try{
      state = TripStatusLoading();
      const storage = FlutterSecureStorage();
      final allValues = await storage.readAll();
      var userId = allValues[StorageKeys.uid];
      var empId = allValues[StorageKeys.empId];
      final res = await service.startOrEndRide(userId!, empId!, address, status, lat, long,tripId);
      print("???????? $res");
      // if(status == "0") {
      //   ref
      //       .read(tripStartProvider.notifier)
      //       .state = true;
      // }else {
      //   print("here----------");
      //   ref
      //       .read(tripEndProvider.notifier)
      //       .state = true;
      // }
      ref.read(tripLoadingProvider.notifier).state = false;
      state = TripStatusSuccess(res['TripID'],tripId != null ? false : true);
    }catch(err){
      state = TripStatusError();
    }
  }

}

abstract class TripStatusStates{}

class TripStatusLoading extends TripStatusStates{}
class TripStatusInitial extends TripStatusStates{}
class TripStatusSuccess extends TripStatusStates{
  final String? tripId;
  final bool isTripStart;
  TripStatusSuccess(this.tripId, this.isTripStart);
}
class TripStatusError extends TripStatusStates{}