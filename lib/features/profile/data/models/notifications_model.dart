// To parse this JSON data, do
//
//     final getNotificationsModel = getNotificationsModelFromJson(jsonString);

import 'dart:convert';

GetNotificationsModel getNotificationsModelFromJson(String str) => GetNotificationsModel.fromJson(json.decode(str));

String getNotificationsModelToJson(GetNotificationsModel data) => json.encode(data.toJson());

class GetNotificationsModel {
  List<ListElement> list;
  String status;

  GetNotificationsModel({
    required this.list,
    required this.status,
  });

  factory GetNotificationsModel.fromJson(Map<String, dynamic> json) => GetNotificationsModel(
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
    "Status": status,
  };
}

class ListElement {
  String notifyId;
  String notifyTitle;
  String notifyContent;
  DateTime date;

  ListElement({
    required this.notifyId,
    required this.notifyTitle,
    required this.notifyContent,
    required this.date,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    notifyId: json["NotifyID"],
    notifyTitle: json["NotifyTitle"],
    notifyContent: json["NotifyContent"],
    date: DateTime.parse(json["Date"]),
  );

  Map<String, dynamic> toJson() => {
    "NotifyID": notifyId,
    "NotifyTitle": notifyTitle,
    "NotifyContent": notifyContent,
    "Date": date.toIso8601String(),
  };
}
