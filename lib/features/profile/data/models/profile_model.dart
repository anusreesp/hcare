// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  String empId;
  String? empName;
  String? userId;
  String? mobile;
  String? email;
  String? photoUrl;
  String? location;
  String? locId;
  String status;
  String? address;
  String punchInStatus;
  String punchOutStatus;
  DateTime? punchInTime;
  String? punchInAddr;
  DateTime? punchOutTime;
  dynamic punchOutAddr;


  ProfileModel({
    required this.empId,
    this.empName,
    required this.userId,
    this.mobile,
    this.email,
    this.photoUrl,
    this.location,
    required this.locId,
    required this.status,
    required this.address,
    required this.punchInTime,
    required this.punchInAddr,
    required this.punchOutTime,
    required this.punchOutAddr,
    required this.punchInStatus,
    required this.punchOutStatus,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    empId: json["EmpID"],
    empName: json["EmpName"],
    userId: json["UserID"],
    mobile: json["Mobile"],
    email: json["Email"],
    photoUrl: json["PhotoURL"],
    location: json["Location"],
    locId: json["LocID"],
    status: json["Status"],
    address: json["Address"],
    punchInTime: DateTime.parse(json["PunchInTime"]),
    punchInAddr: json["PunchInAddr"],
    punchOutTime: DateTime.parse(json["PunchOutTime"]),
    punchOutAddr: json["PunchOutAddr"],
    punchOutStatus: json["PunchOutSts"],
    punchInStatus: json["PunchInSts"]
  );

  Map<String, dynamic> toJson() => {
    "EmpID": empId,
    "EmpName": empName,
    "UserID": userId,
    "Mobile": mobile,
    "Email": email,
    "PhotoURL": photoUrl,
    "Location": location,
    "LocID": locId,
    "Status": status,
    "Address": address,
    "PunchInTime": punchInTime?.toIso8601String(),
    "PunchInAddr": punchInAddr,
    "PunchOutTime": punchOutTime?.toIso8601String(),
    "PunchOutAddr": punchOutAddr,
    "PunchInSts":punchInStatus,
    "PunchOutSts":punchOutStatus
  };
}
