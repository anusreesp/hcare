import 'package:drmohans_homecare_flutter/common/widgets/space.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TripTypeContainerComponent extends StatelessWidget {
  const TripTypeContainerComponent({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isActive,
  });
  final String title;
  final String icon;
  //final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: HcTheme.white1Color)),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/svg/$icon',
              color: HcTheme.white1Color,
            ),
            // Icon(
            //   icon,
            //   color: HcTheme.white2Color,
            //   size: 16,
            // ),
            Space.x(5),
            Text(
              title,
              style: mon12White,
            ),
            Space.x(5),
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: isActive
                    ? HcTheme.lightGreen2Color
                    : HcTheme.lightGrey1Color,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Icon(
                Icons.check,
                color: HcTheme.greenColor,
                size: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
