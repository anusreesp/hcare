// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RideItem _$RideItemFromJson(Map<String, dynamic> json) => RideItem(
      orderId: json['OrderID'] as String?,
      name: json['Name'] as String?,
      mrn: json['MRN'] as String?,
      mobile: json['Mobile'] as String?,
      address: json['Address'] as String?,
      collDeliverTime: json['CollectionTime_DeliveryTime'] as String?,
      photoUrl: json['PhotoURL'] as String?,
      date: json['Date'] as String?,
      hcType: json['HCType'] as String?,
      hcStatus: json['HCStatus'] as String?,
      pickedStatus: json['PickedStatus'] as String?,
      schdeuleStatus: json['SchdeuleStatus'] as String?,
      rideStatus: json['RideStatus'] as String?,
    );

Map<String, dynamic> _$RideItemToJson(RideItem instance) => <String, dynamic>{
      'OrderID': instance.orderId,
      'Name': instance.name,
      'MRN': instance.mrn,
      'Mobile': instance.mobile,
      'Address': instance.address,
      'CollectionTime_DeliveryTime': instance.collDeliverTime,
      'PhotoURL': instance.photoUrl,
      'Date': instance.date,
      'HCType': instance.hcType,
      'HCStatus': instance.hcStatus,
      'PickedStatus': instance.pickedStatus,
      'SchdeuleStatus': instance.schdeuleStatus,
      'RideStatus': instance.rideStatus,
    };
