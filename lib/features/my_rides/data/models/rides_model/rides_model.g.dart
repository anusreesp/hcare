// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rides_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RidesModel _$RidesModelFromJson(Map<String, dynamic> json) => RidesModel(
      rideList: (json['lst'] as List<dynamic>?)
              ?.map((e) => RideItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: json['Status'] as String?,
      assigned: json['Assigned'] as String? ?? "0",
      pending: json['Pending'] as String? ?? "0",
      rescheduled: json['Rescheduled'] as String? ?? "0",
      unscheduled: json['Unscheduled'] as String? ?? "0",
    );

Map<String, dynamic> _$RidesModelToJson(RidesModel instance) =>
    <String, dynamic>{
      'Assigned': instance.assigned,
      'Unscheduled': instance.unscheduled,
      'Pending': instance.pending,
      'Rescheduled': instance.rescheduled,
      'lst': instance.rideList,
      'Status': instance.status,
    };
