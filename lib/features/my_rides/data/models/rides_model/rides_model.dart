import 'package:json_annotation/json_annotation.dart';

import '../../../../../common/data/models/ride_item.dart';

part 'rides_model.g.dart';

@JsonSerializable()
class RidesModel {
  @JsonKey(name: "Assigned")
  String assigned;
  @JsonKey(name: "Unscheduled")
  String unscheduled;
  @JsonKey(name: "Pending")
  String pending;
  @JsonKey(name: "Rescheduled")
  String rescheduled;
  @JsonKey(name: 'lst')
  List<RideItem> rideList;
  @JsonKey(name: 'Status')
  String? status;

  RidesModel(
      {this.rideList = const [],
      this.status,
      this.assigned = "0",
      this.pending = "0",
      this.rescheduled = "0",
      this.unscheduled = "0"});

  factory RidesModel.fromJson(Map<String, dynamic> json) {
    return _$RidesModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RidesModelToJson(this);
}
