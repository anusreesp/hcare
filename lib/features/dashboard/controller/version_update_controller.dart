import 'dart:io';

import 'package:drmohans_homecare_flutter/features/dashboard/data/services/dashboard_service.dart';
import 'package:drmohans_homecare_flutter/services/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

final versionUpdateProvider = StateNotifierProvider<VersionUpdateController,VersionUpdateStates>((ref) {
  final service = ref.watch(dashboardServiceProvider);
  return VersionUpdateController(service);
});

class VersionUpdateController extends StateNotifier<VersionUpdateStates>{
  final DashboardServices service;
  VersionUpdateController(this.service) : super(VersionUpdateInitial()){
    getVersionUpdate();
  }

  getVersionUpdate()async{
    try{
      state = VersionUpdateLoading();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      bool platform = Platform.isAndroid;
      const storage = FlutterSecureStorage();
      final allValues = await storage.readAll();
      var userId = allValues[StorageKeys.uid];
      final res = await service.versionUpdate(packageInfo.version, platform == true ? 'android' : 'ios', userId);
      print(">>>>>>>>>>>-----$res");
      state = VersionUpdateLoaded(res);
    }catch(e){
      print(":>>:::::::::::::$e");
      state = VersionUpdateError();
    }
  }

}

abstract class VersionUpdateStates{}

class VersionUpdateInitial extends VersionUpdateStates{}
class VersionUpdateLoading extends VersionUpdateStates{}
class VersionUpdateLoaded extends VersionUpdateStates{
  final dynamic res;
  VersionUpdateLoaded(this.res);
}
class VersionUpdateError extends VersionUpdateStates{}