import 'package:drmohans_homecare_flutter/features/profile/data/models/notifications_model.dart';
import 'package:drmohans_homecare_flutter/features/profile/data/services/profile_services.dart';
import 'package:drmohans_homecare_flutter/services/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = StateNotifierProvider.autoDispose<NotificationController,NotificationStates>((ref){
  final service = ref.watch(profileServiceProvider);
  final authData = ref.watch(flutterStorageProvider);
  return NotificationController(service,authData);
});

class NotificationController extends StateNotifier<NotificationStates>{
  final ProfileServices service;
  final Map<String, String> authData;
  NotificationController(this.service, this.authData) : super(NotificationInitial()){
    getNotification();
  }

  getNotification()async{
    try{
      state = NotificationLoading();
      var userId = authData[StorageKeys.uid];
      var empId = authData[StorageKeys.empId];
      final data =  await service.getNotifications(userId!, empId!);
      filterNotifications(data);
    }catch(err){
      NotificationError();
    }
  }

  filterNotifications(GetNotificationsModel list)async{
    try{
      final now = DateTime.now();
      final List<ListElement> today = [];
      final List<ListElement> yesterday = [];
      final List<ListElement> earlier = [];
      for (var element in list.list) {
        final difference = now.difference(element.date);
        if(difference.inDays == 0){
          today.add(element);
        } else if(difference.inDays == 1){
          yesterday.add(element);
        }else if(difference.inDays > 2){
          earlier.add(element);
        }
      }
      state = NotificationLoaded(today,yesterday,earlier);
    }catch(_){
    }
  }
}

abstract class NotificationStates{}

class NotificationInitial extends NotificationStates{}
class NotificationLoading extends NotificationStates{}
class NotificationLoaded extends NotificationStates{
  final List<ListElement> today;
  final List<ListElement> yesterday;
  final List<ListElement> earlier;
  NotificationLoaded(this.today, this.yesterday, this.earlier);
}
class NotificationError extends NotificationStates{}