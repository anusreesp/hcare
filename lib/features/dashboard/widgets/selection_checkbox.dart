import 'package:flutter/material.dart';

import '../../../theme.dart';

class SelectionCheckbox extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  const SelectionCheckbox(
      {super.key, required this.onTap, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: HcTheme.greenColor)),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        child: Row(
          children: [
            const Icon(
              Icons.ac_unit,
              size: 18,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 4.0, right: 8),
              child: Text(
                'DELIVERIES',
                style: mon12BlackMedium,
              ),
            ),
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: isActive ? HcTheme.greenColor : HcTheme.lightGrey2Color,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
