import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/cupertino.dart';

class GreyCard extends StatelessWidget {
  final Widget? child;
  final double borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  const GreyCard(
      {Key? key,
      this.child,
      this.borderRadius = 6.0,
      this.padding,
      this.margin,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: HcTheme.white1Color,
        boxShadow: const [
          BoxShadow(
            color: HcTheme.lightGrey1Color,
            blurRadius: 3,
            spreadRadius: 0.5,
            offset: Offset(0.0, 4.0), // shadow direction: bottom right
          ),
        ],
      ),
      child: child,
    );
  }
}
