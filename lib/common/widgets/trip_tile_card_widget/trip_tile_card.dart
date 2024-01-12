import 'package:drmohans_homecare_flutter/common/data/models/ride_item.dart';
import 'package:flutter/material.dart';
import '../grey_container.dart';
import '../space.dart';
import 'components/export_trip_tile_component.dart';

class TripCardTile extends StatelessWidget {
  final VoidCallback onViewDetailsClick;
  final RideItem rideItem;

  const TripCardTile({
    super.key,
    required this.rideItem,
    required this.onViewDetailsClick,
  });

  @override
  Widget build(BuildContext context) {
    return GreyCard(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          ///First row
          ///This row includes Image, Name, RideId, ride type, call button, and status of delivery
          NameImageCallRow(rideItem: rideItem),
          Space.y(10),

          ///Second row
          ///This row includes Date, time and trip completed label for trip completed screen
          DateAndTimeRow(rideItem: rideItem),
          Space.y(10),

          /// Third Row
          /// This row includes the location Icon, address and view details button
          AddressAndViewDetailsRow(
            rideItem: rideItem,
            onViewDetailsClick: onViewDetailsClick,
          )
        ],
      ),
    );
  }
}
