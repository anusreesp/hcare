// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

import '../../../../common/data/models/ride_item.dart';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  final String empId;
  final String userId;
  final String assigned;
  final String unscheduled;
  final String pending;
  final String completed;
  final String rescheduled;
  final String cancelled;
  final String travelKms;
  final String travelHrs;
  final List<RideItem> lst;
  final String status;
  final String punchInStatus;
  final String punchOutStatus;
  final String punchInTime;
  final String punchOutTime;
  final String tripId;
  final String tripStartSts;
  final String tripEndSts;

  DashboardModel({
    required this.empId,
    required this.userId,
    required this.assigned,
    required this.unscheduled,
    required this.pending,
    required this.completed,
    required this.rescheduled,
    required this.cancelled,
    required this.travelKms,
    required this.travelHrs,
    required this.lst,
    required this.status,
    required this.punchInStatus,
    required this.punchOutStatus,
    required this.punchInTime,
    required this.punchOutTime,
    required this.tripId,
    required this.tripStartSts,
    required this.tripEndSts,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        empId: json["EmpID"],
        userId: json["UserID"],
        assigned: json["Assigned"],
        unscheduled: json["Unscheduled"],
        pending: json["Pending"],
        completed: json["Completed"],
        rescheduled: json["Rescheduled"],
        cancelled: json["Cancelled"],
        travelKms: json["TravelKms"],
        travelHrs: json["TravelHrs"],
        lst: (json['lst'] as List<dynamic>?)
                ?.map((e) => RideItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        status: json["Status"],
        punchInStatus: json["PunchInSts"],
        punchInTime: json["PunchIn"],
        punchOutStatus: json["PunchOutSts"],
        punchOutTime: json["PunchOut"],
        tripId: json['TripID'],
        tripEndSts: json["TripEndSts"],
        tripStartSts: json["TripStartSts"],
      );

  Map<String, dynamic> toJson() => {
        "EmpID": empId,
        "UserID": userId,
        "Assigned": assigned,
        "Unscheduled": unscheduled,
        "Pending": pending,
        "Completed": completed,
        "Rescheduled": rescheduled,
        "Cancelled": cancelled,
        "TravelKms": travelKms,
        "TravelHrs": travelHrs,
        "lst": List<dynamic>.from(lst.map((x) => x.toJson())),
        "Status": status,
        "PunchInSts": punchInStatus,
        "PunchOutSts": punchOutStatus,
        "PunchIn": punchInTime,
        "PunchOut": punchOutTime,
        "TripStartSts": tripStartSts,
        "TripEndSts": tripEndSts,
        "PunchInSts": punchInStatus,
        "PunchOutSts": punchOutStatus,
        "PunchIn": punchInTime,
        "PunchOut": punchOutTime,
        'TripID': tripId,
      };
}

class Lst {
  final String orderId;
  final String name;
  final String mrn;
  final String mobile;
  final String address;
  final DateTime collDeliverTime;
  final dynamic photoUrl;
  final DateTime date;
  final HcType hcType;
  final Status hcStatus;
  final String pickedStatus;
  final Status schdeuleStatus;

  Lst({
    required this.orderId,
    required this.name,
    required this.mrn,
    required this.mobile,
    required this.address,
    required this.collDeliverTime,
    required this.photoUrl,
    required this.date,
    required this.hcType,
    required this.hcStatus,
    required this.pickedStatus,
    required this.schdeuleStatus,
  });

  factory Lst.fromJson(Map<String, dynamic> json) => Lst(
        orderId: json["OrderID"],
        name: json["Name"],
        mrn: json["MRN"],
        mobile: json["Mobile"],
        address: json["Address"],
        collDeliverTime: DateTime.parse(json["Coll_DeliverTime"]),
        photoUrl: json["PhotoURL"],
        date: DateTime.parse(json["Date"]),
        hcType: hcTypeValues.map[json["HCType"]]!,
        hcStatus: statusValues.map[json["HCStatus"]]!,
        pickedStatus: json["PickedStatus"],
        schdeuleStatus: statusValues.map[json["SchdeuleStatus"]]!,
      );

  Map<String, dynamic> toJson() => {
        "OrderID": orderId,
        "Name": name,
        "MRN": mrn,
        "Mobile": mobile,
        "Address": address,
        "Coll_DeliverTime": collDeliverTime.toIso8601String(),
        "PhotoURL": photoUrl,
        "Date": date.toIso8601String(),
        "HCType": hcTypeValues.reverse[hcType],
        "HCStatus": statusValues.reverse[hcStatus],
        "PickedStatus": pickedStatus,
        "SchdeuleStatus": statusValues.reverse[schdeuleStatus],
      };
}

enum Status { UNSCHEDULED }

final statusValues = EnumValues({"Unscheduled": Status.UNSCHEDULED});

enum HcType { COLLECTION }

final hcTypeValues = EnumValues({"Collection": HcType.COLLECTION});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
