import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconText extends StatelessWidget {
  final String? iconPath, title;
  final TextStyle style;
  final double? iconWidth, iconHeight, space;
  final Color? iconColor;

  const IconText(
      {super.key,
      required this.iconPath,
      this.title,
      required this.style,
      this.iconWidth,
      this.iconHeight,
      this.space,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/svg/$iconPath.svg",
          width: iconWidth,
          height: iconHeight,
          color: iconColor,
        ),
        SizedBox(
          width: space ?? 6,
        ),
        Text(
          title ?? "",
          style: style,
          maxLines: 2,
        )
      ],
    );
  }
}
