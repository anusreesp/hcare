// To parse this JSON data, do
//
//     final handOverDetailsModel = handOverDetailsModelFromJson(jsonString);

import 'dart:convert';

HandOverDetailsModel handOverDetailsModelFromJson(String str) =>
    HandOverDetailsModel.fromJson(json.decode(str));

String handOverDetailsModelToJson(HandOverDetailsModel data) =>
    json.encode(data.toJson());

class HandOverDetailsModel {
  final String patientCount;
  final String samplesCount;
  final String cash;
  final String card;
  final String ewallet;
  final String total;
  final String desc;
  final String status;

  HandOverDetailsModel({
    required this.patientCount,
    required this.samplesCount,
    required this.cash,
    required this.card,
    required this.ewallet,
    required this.total,
    required this.desc,
    required this.status,
  });

  factory HandOverDetailsModel.fromJson(Map<String, dynamic> json) =>
      HandOverDetailsModel(
        patientCount: json["PatientCount"],
        samplesCount: json["SamplesCount"],
        cash: json["Cash"],
        card: json["Card"],
        ewallet: json["Ewallet"],
        total: json["Total"],
        desc: json["Desc"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "PatientCount": patientCount,
        "SamplesCount": samplesCount,
        "Cash": cash,
        "Card": card,
        "Ewallet": ewallet,
        "Total": total,
        "Desc": desc,
        "Status": status,
      };
}
