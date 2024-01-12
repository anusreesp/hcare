import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';

class RadioButtonTextTile extends StatelessWidget {
  final String? title;
  final bool value;
  final GestureTapCallback onTap;
  final onChanged;
  const RadioButtonTextTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onTap,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: size.height * 0.055,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              width: 1,
              color:
                  value == true ? HcTheme.greenColor : HcTheme.lightGrey2Color),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title ?? "",
                      style: mon14BlackSB,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Stack(
              children: [
                Radio(
                    value: true,
                    groupValue: true,
                    onChanged: onChanged,
                    activeColor: value == true
                        ? HcTheme.greenColor
                        : HcTheme.lightGrey2Color),
                Container(
                  height: 45,
                  width: 45,
                  color: Colors.transparent,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
