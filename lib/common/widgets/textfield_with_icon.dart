import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextFieldWithIcon extends StatelessWidget {
  final double height;
  final double width;
  final String icon;
  final String? hint;
  final TextEditingController controller;
  const TextFieldWithIcon(
      {Key? key,
      required this.height,
      required this.width,
      required this.icon,
      required this.controller,
      this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: HcTheme.lightGrey2Color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            icon == "" ? const SizedBox.shrink() : SvgPicture.asset(icon),
            const SizedBox(
              width: 14.22,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hint ?? "",
                    style: const TextStyle(
                        fontSize: 12, color: HcTheme.lightGrey3Color)),
                Expanded(
                  child: SizedBox(
                    width: width * 0.65,
                    height: 4,
                    child: TextField(
                      minLines: 1,
                      controller: controller,
                      style: mon14Black,
                      keyboardType: TextInputType.number,
                      cursorColor: HcTheme.blueColor,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
