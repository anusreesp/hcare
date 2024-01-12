import 'package:drmohans_homecare_flutter/common/widgets/grey_container.dart';
import 'package:drmohans_homecare_flutter/common/widgets/icon_text.dart';
import 'package:drmohans_homecare_flutter/common/widgets/main_green_button.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PunchedInTab extends StatelessWidget {
  final String address;
  final String time;
  final String title;
  const PunchedInTab({Key? key, required this.address,required this.time, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GreyCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 14.0, vertical: 16),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                 IconText(
                    iconPath: 'profile/punched_in',
                    title: title,
                    style: mon14BlackSB),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset("assets/icons/svg/profile/location_grey.svg"),
                    const SizedBox(
                      width:  6,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.50,child: Text(address,style: mon10darkGrey1,))
                  ],
                )
              ],
            ),
            Text(
              time,
              style: mon12lightGrey3,
            )
          ],
        ),
      ),
    );
  }
}

class PunchButton extends StatelessWidget {
  final String icon;
  final String subtitle;
  final String title;
  final String buttonTitle;
  final Function() onPressed ;
  const PunchButton({Key? key, required this.icon, required this.subtitle,required this.title, required this.buttonTitle, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GreyCard(
        child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12.0, vertical: 12),
            child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  IconText(
                      iconPath: icon,
                      title: title,
                      style: mon14BlackSB),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    subtitle,
                    style: mon12lightGrey3,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  MainGreenButton(
                    title: buttonTitle,
                    textStyle: mon12BlackSB,
                    onPressed: onPressed,
                    outlined: true,
                    height: 40,
                  ),
                ]
            )
        )
    );
  }
}

