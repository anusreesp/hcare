import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MainGreenButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double height;
  final bool outlined;
  final String? iconName;
  final TextStyle? textStyle;
  final double borderRadius;
  final Color? iconColor;
  final bool isLoading;
  const MainGreenButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.height = 44,
    this.outlined = false,
    this.iconName,
    this.borderRadius = 7,
    this.textStyle,
    this.iconColor,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: outlined ? null : HcTheme.greenColor,
      minWidth: double.infinity,
      height: height,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: outlined
            ? const BorderSide(color: HcTheme.greenColor, width: 2)
            : BorderSide.none,
      ),
      onPressed: onPressed,
      child: isLoading
          ? LoadingAnimationWidget.staggeredDotsWave(
              color: HcTheme.whiteColor,
              size: 35,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconName != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: SvgPicture.asset(
                      'assets/icons/svg/$iconName.svg',
                      colorFilter: iconColor == null
                          ? null
                          : ColorFilter.mode(iconColor!, BlendMode.srcIn),
                    ),
                  ),
                Text(
                  title,
                  style: textStyle ??
                      TextStyle(
                          color: outlined ? HcTheme.greenColor : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                ),
              ],
            ),
    );
  }
}
