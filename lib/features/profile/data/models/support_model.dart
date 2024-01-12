// To parse this JSON data, do
//
//     final supportModel = supportModelFromJson(jsonString);

import 'dart:convert';

SupportModel supportModelFromJson(String str) =>
    SupportModel.fromJson(json.decode(str));

String supportModelToJson(SupportModel data) => json.encode(data.toJson());

class SupportModel {
  final String mobile;
  final String mobileDesc;
  final String email;
  final String emailDesc;
  final String status;

  SupportModel({
    required this.mobile,
    required this.mobileDesc,
    required this.email,
    required this.emailDesc,
    required this.status,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) => SupportModel(
        mobile: json["Mobile"],
        mobileDesc: json["MobileDesc"],
        email: json["Email"],
        emailDesc: json["EmailDesc"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "Mobile": mobile,
        "MobileDesc": mobileDesc,
        "Email": email,
        "EmailDesc": emailDesc,
        "Status": status,
      };
}
