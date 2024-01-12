import 'package:json_annotation/json_annotation.dart';

part 'ride_item.g.dart';

@JsonSerializable()
class RideItem {
  @JsonKey(name: 'OrderID')
  String? orderId;
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'MRN')
  String? mrn;
  @JsonKey(name: 'Mobile')
  String? mobile;
  @JsonKey(name: 'Address')
  String? address;
  @JsonKey(name: 'CollectionTime_DeliveryTime')
  String? collDeliverTime;
  @JsonKey(name: 'PhotoURL')
  String? photoUrl;
  @JsonKey(name: 'Date')
  String? date;
  @JsonKey(name: 'HCType')
  String? hcType;
  @JsonKey(name: 'HCStatus')
  String? hcStatus;
  @JsonKey(name: 'PickedStatus')
  String? pickedStatus;
  @JsonKey(name: 'SchdeuleStatus')
  String? schdeuleStatus;
  @JsonKey(name: "RideStatus")
  String? rideStatus;

  RideItem(
      {this.orderId,
      this.name,
      this.mrn,
      this.mobile,
      this.address,
      this.collDeliverTime,
      this.photoUrl,
      this.date,
      this.hcType,
      this.hcStatus,
      this.pickedStatus,
      this.schdeuleStatus,
      this.rideStatus});

  factory RideItem.fromJson(Map<String, dynamic> json) =>
      _$RideItemFromJson(json);

  Map<String, dynamic> toJson() => _$RideItemToJson(this);
}
