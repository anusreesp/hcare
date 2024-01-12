import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme.dart';

class ProgressIndicatorAppointment extends ConsumerWidget {
  final int completeIndex;
  final int length;
  const ProgressIndicatorAppointment({
    Key? key,
    this.completeIndex = 0,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return CircleAvatar(
            backgroundColor: (index == 0 || completeIndex >= index)
                ? HcTheme.greenColor
                : HcTheme.lightGrey2Color,
            radius: completeIndex >= index ? null : 16,
            child: (index == 0 || completeIndex >= index)
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          );
        },
        separatorBuilder: (context, index) => Center(
          child: Container(
            width: 28,
            height: 1,
            color: (completeIndex >= index + 1)
                ? HcTheme.greenColor
                : HcTheme.lightGrey2Color,
          ),
        ),
        itemCount: length,
      ),
    );
  }
}
