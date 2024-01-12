import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme.dart';

class NavButton extends StatelessWidget {
  final bool isActive;
  final String iconName;
  const NavButton({super.key, required this.isActive, required this.iconName});

  @override
  Widget build(BuildContext context) {
    return isActive
        ? Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: HcTheme.blueColor)),
            child: SvgPicture.asset('assets/icons/svg/$iconName.svg'))
        : Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              'assets/icons/svg/$iconName.svg',
              color: Colors.black,
            ));
  }
}
