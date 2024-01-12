import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool status;
  final String title;
  const CustomCheckbox({Key? key, required this.status, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          height: 18,
          width: 18,
          decoration: BoxDecoration(
            color: status ? HcTheme.greenColor : HcTheme.lightGrey2Color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(title, style: mon14BlackSB),
      ],
    );
  }
}
