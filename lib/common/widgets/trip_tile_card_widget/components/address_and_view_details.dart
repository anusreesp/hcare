import 'package:drmohans_homecare_flutter/common/data/models/ride_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../theme.dart';
import '../../green_border_button.dart';
import '../../space.dart';

class AddressAndViewDetailsRow extends StatelessWidget {
  const AddressAndViewDetailsRow({
    super.key,
    required this.rideItem,
    required this.onViewDetailsClick,
  });

  final RideItem rideItem;
  final VoidCallback onViewDetailsClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/icons/svg/location.svg'),
        Space.x(5),
        Expanded(
            child: Text(
          "${rideItem.address}",
          style: mon12BlackMedium,
        )),
        Space.x(5),
        GreenBorderButtonRounded(
          borderWidth: 2,
          borderColor: HcTheme.greenColor,
          borderRadius: 30,
          onPressed: onViewDetailsClick,
          paddingAll: 5,
          child: const Text('View details'),
        )
      ],
    );
  }
}
