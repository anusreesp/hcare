import 'package:drmohans_homecare_flutter/features/collection/controllers/razorpay_link_sent.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/export_collection_controllers.dart';

class PaymentMethodItem extends ConsumerWidget {
  const PaymentMethodItem(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.type});
  final String title;
  final bool isSelected;
  final PaymentType type;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        if (type != PaymentType.razorpay) {
          ref.read(razorpayLinkSentProvider.notifier).state = false;
        }
        ref.read(paymentMethodSelectProvider.notifier).state = type;
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
                color:
                    isSelected ? HcTheme.greenColor : HcTheme.lightGrey2Color)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: mon14BlackSB,
            ),
            Icon(
              Icons.radio_button_checked,
              color: isSelected ? HcTheme.greenColor : HcTheme.lightGrey2Color,
            )
          ],
        ),
      ),
    );
  }
}
