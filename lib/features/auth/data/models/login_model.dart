// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String empId;
  dynamic empName;
  dynamic userId;
  String token;
  String? status;

  LoginModel({
    required this.empId,
    required this.empName,
    required this.userId,
    required this.token,
    this.status,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        empId: json["EmpID"],
        empName: json["EmpName"],
        userId: json["UserID"],
        token: json["token"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "EmpID": empId,
        "EmpName": empName,
        "UserID": userId,
        "token": token,
        "Status": status,
      };
}
