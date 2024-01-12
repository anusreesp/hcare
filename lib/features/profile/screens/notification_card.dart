import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final String iconPath, title;
  final Widget? child;
  final DateTime duration;
  const NotificationCard(
      {super.key,
      required this.iconPath,
      required this.title,
      required this.duration,
      this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
              color: HcTheme.lightBlue3Color,
              borderRadius: BorderRadius.circular(4)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SvgPicture.asset(
              'assets/icons/svg/notification/$iconPath.svg',
              width: 38,
              height: 38,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(
                        title,
                        style: mon14BlackSB,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(child: child),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      child: Text(
                        timeText(duration),
                        style: mon12lightGrey3,
                        softWrap: true,
                      ),
                    ),
                  ]),
            ),
          ])),
    );
  }
  String timeText(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes <= 60) {
      return '${diff.inMinutes} min ago';
    }

    if (diff.inHours <= 24) {
      return '${diff.inHours}h ago';
    }

    if (diff.inDays == 1) {
      return '1d ago';
    }
    if (diff.inDays <= 7) {
      return '${diff.inDays}d ago';
    }
    if (diff.inDays >= 7) {
      int weeks = diff.inDays ~/ 7;
      return '${weeks}w ago';
    }
    if (diff.inDays > 30) {
      int months = diff.inDays ~/ 30;
      return '${months}m ago';
    }

    return DateFormat('dd MMMM yyyy').format(dateTime);
  }
}
