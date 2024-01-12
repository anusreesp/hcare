import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';

class GreenBorderButtonRounded extends StatelessWidget {
  const GreenBorderButtonRounded({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderRadius = 30,
    this.borderColor = HcTheme.lightGreen2Color,
    this.borderWidth = 1,
    this.paddingAll = 12,
  });
  final Function() onPressed;
  final Widget child;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final double paddingAll;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          width: borderWidth,
          color: borderColor,
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.all(paddingAll),
        child: child,
      ),
    );
  }
}
