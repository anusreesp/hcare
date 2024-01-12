import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dashed_line.dart';

class LocationThreeSteps extends StatelessWidget {
  final bool? isThreeLocation;
  const LocationThreeSteps({super.key, this.isThreeLocation = true});

  final String locationPath = "assets/icons/svg/yellow_location.svg";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(locationPath),
          const Padding(
            padding: EdgeInsets.only(left: 7, bottom: 13),
            child: DashedLine(
              width: 10,
              strokeWidth: 1,
              dashedWidth: 3,
              dashedSpace: 3,
            ),
          ),
          if (isThreeLocation == true)
            SvgPicture.asset(
              locationPath,
              color: HcTheme.blueColor,
            ),
          if (isThreeLocation == true)
            const Padding(
              padding: EdgeInsets.only(left: 7, bottom: 22),
              child: DashedLine(
                width: 19,
                strokeWidth: 1,
                dashedWidth: 3,
                dashedSpace: 3,
              ),
            ),
          SvgPicture.asset(
            locationPath,
            color: HcTheme.greenColor,
          ),
        ],
      ),
    );
  }
}
