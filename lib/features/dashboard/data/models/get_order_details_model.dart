// To parse this JSON data, do
//
//     final getOrderDetails = getOrderDetailsFromJson(jsonString);

import 'dart:convert';

GetOrderDetails getOrderDetailsFromJson(String str) =>
    GetOrderDetails.fromJson(json.decode(str));

String getOrderDetailsToJson(GetOrderDetails data) =>
    json.encode(data.toJson());

class GetOrderDetails {
  String orderId;
  String name;
  String mrn;
  String age;
  String gender;
  String mobile;
  String address;
  DateTime collDeliverTime;
  dynamic photoUrl;
  DateTime date;
  String hcType;
  String hcStatus;
  String pickedStatus;
  String schdeuleStatus;
  String rideStatus;
  List<ListElement> list;
  String grossAmount;
  String discount;
  String discountVisible;
  String netAmount;
  String status;
  String lat;
  String lng;
  bool vitalsVisible;
  bool quesVisible;
  bool serviceVIsible;
  bool payConfigVisible;

  GetOrderDetails(
      {required this.orderId,
      required this.name,
      required this.mrn,
      required this.age,
      required this.mobile,
      required this.address,
      required this.collDeliverTime,
      required this.photoUrl,
      required this.date,
      required this.hcType,
      required this.hcStatus,
      required this.pickedStatus,
      required this.schdeuleStatus,
      required this.rideStatus,
      required this.list,
      required this.grossAmount,
      required this.discount,
      required this.discountVisible,
      required this.netAmount,
      required this.status,
      required this.gender,
      required this.lat,
      required this.lng,
      required this.payConfigVisible,
      required this.serviceVIsible,
      required this.quesVisible,
      required this.vitalsVisible});

  factory GetOrderDetails.fromJson(Map<String, dynamic> json) =>
      GetOrderDetails(
        orderId: json["OrderID"],
        name: json["Name"],
        mrn: json["MRN"],
        age: json["Age"],
        mobile: json["Mobile"],
        address: json["Address"],
        collDeliverTime: DateTime.parse(json["CollectionTime_DeliverTime"]),
        photoUrl: json["PhotoURL"],
        date: DateTime.parse(json["Date"]),
        hcType: json["HCType"],
        hcStatus: json["HCStatus"],
        pickedStatus: json["PickedStatus"],
        schdeuleStatus: json["SchdeuleStatus"],
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
        grossAmount: json["GrossAmount"],
        discount: json["Discount"],
        discountVisible: json["DiscountVisible"],
        netAmount: json["NetAmount"],
        status: json["Status"],
        gender: json["Gender"],
        lat: json['Lat'],
        lng: json['Lng'],
        rideStatus: json['RideStatus'],
        payConfigVisible: (json['PayConfigVisible'].toLowerCase() == "true"),
        quesVisible: (json['QuesVisible'].toLowerCase() == "true"),
        serviceVIsible: (json['ServiceVisible'].toLowerCase() == "true"),
        vitalsVisible: (json['VitalsVisible'].toLowerCase() == "true"),
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
        "HCType": hcType,
        "HCStatus": hcStatus,
        "PickedStatus": pickedStatus,
        "SchdeuleStatus": schdeuleStatus,
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "GrossAmount": grossAmount,
        "Discount": discount,
        "DiscountVisible": discountVisible,
        "NetAmount": netAmount,
        "Status": status,
        "Gender": gender,
        "Age": age,
        "Lat": lat,
        "Lng": lng,
        "RideStatus": rideStatus,
      };
}

class ListElement {
  String serviceId;
  String serviceCode;
  String serviceName;
  String serviceAmount;
  String description;

  ListElement({
    required this.serviceId,
    required this.serviceCode,
    required this.serviceName,
    required this.serviceAmount,
    required this.description,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        serviceId: json["ServiceID"],
        serviceCode: json["ServiceCode"],
        serviceName: json["ServiceName"],
        serviceAmount: json["ServiceAmount"],
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "ServiceID": serviceId,
        "ServiceCode": serviceCode,
        "ServiceName": serviceName,
        "ServiceAmount": serviceAmount,
        "Description": description,
      };
}
