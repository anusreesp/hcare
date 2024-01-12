import 'package:drmohans_homecare_flutter/common/data/models/ride_item.dart';

class History {
  final List<RideItem> lst;

  final String? status;
  final String? totalCount;
  final String? finishedCount;

  History({
    required this.lst,
    required this.status,
    required this.finishedCount,
    required this.totalCount,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        lst: List<RideItem>.from(json["lst"].map((x) => RideItem.fromJson(x))),
        status: json["Status"],
        finishedCount: json["FinishedCount"],
        totalCount: json["TotalCount"],
      );

  Map<String, dynamic> toJson() => {
        "lst": List<dynamic>.from(lst.map((x) => x.toJson())),
        "Status": status,
      };
}
