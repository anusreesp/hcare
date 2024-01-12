import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    super.key,
    required this.onButtonSelected,
    required this.buttonLabel,
    required this.isSelected,
  });
  final Function(String) onButtonSelected;
  final String buttonLabel;
  final bool? isSelected;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onButtonSelected(buttonLabel);
      },
      child: Container(
        padding: const EdgeInsets.all(7),
        height: 40,
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            width: 1,
            color: HcTheme.lightGrey2Color,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              buttonLabel,
              style: mon12Black,
            ),
            Icon(
              Icons.radio_button_checked,
              color: isSelected == null
                  ? HcTheme.lightGrey2Color
                  : isSelected!
                      ? HcTheme.greenColor
                      : HcTheme.lightGrey2Color,
            )
          ],
        ),
      ),
    );
  }
}
