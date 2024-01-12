import 'package:drmohans_homecare_flutter/common/data/models/ride_item.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../space.dart';

class DateAndTimeRow extends StatelessWidget {
  const DateAndTimeRow({
    super.key,
    required this.rideItem,
  });

  final RideItem rideItem;

  @override
  Widget build(BuildContext context) {
    //------------------------------//
    final String date =
        DateFormat('dd MMM yyyy').format(DateTime.parse(rideItem.date!));
    final String time = DateFormat('h:mm a').format(DateTime.parse(
      rideItem.collDeliverTime ?? "1900-01-01T00:00:00",
    ));
    //-----------------------------//
    return Row(
      children: [
        SvgPicture.asset('assets/icons/svg/calendar_icon.svg'),
        Space.x(4),
        Text(
          date,
          style: mon12lightGrey3,
        ),
        Container(
          height: 12,
          width: 1,
          color: HcTheme.lightGrey3Color,
          margin: const EdgeInsets.symmetric(horizontal: 12),
        ),
        SvgPicture.asset('assets/icons/svg/clock_icon.svg'),
        Space.x(4),
        Text(
          time,
          style: mon12lightGrey3,
        ),
        const Spacer(),
        Visibility(
          visible: rideItem.hcStatus != "",
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: rideItem.hcStatus == "Completed",
                child: SvgPicture.asset(
                  'assets/icons/svg/green_tick.svg',
                  height: 10,
                  colorFilter: const ColorFilter.mode(
                      HcTheme.greenColor, BlendMode.srcIn),
                ),
              ),
              Space.x(2),
              Text(
                '${rideItem.hcStatus}',
                style: mon10Green.copyWith(
                    color: rideItem.hcStatus == "Cancelled"
                        ? HcTheme.redColor
                        : rideItem.hcStatus == "Completed"
                            ? HcTheme.greenColor
                            : HcTheme.blueColor),
              ),
            ],
          ),
        )
      ],
    );
  }
}
