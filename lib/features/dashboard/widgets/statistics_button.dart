import 'package:flutter/material.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatisticsButton extends StatelessWidget {
  final String count;
  final String title;
  final VoidCallback onTap;
  final String svgIcon;
  const StatisticsButton(
      {super.key,
      required this.count,
      required this.title,
      required this.onTap,
      required this.svgIcon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 126,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count,
              style: const TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(svgIcon),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    title,
                    style: mon12White,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_sharp,
                  size: 16,
                  color: Colors.white,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
