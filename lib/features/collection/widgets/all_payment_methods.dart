import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/space.dart';
import '../controllers/export_collection_controllers.dart';
import 'payment_method_item_widget.dart';

class PaymentMethods extends ConsumerWidget {
  const PaymentMethods({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seletecType = ref.watch(paymentMethodSelectProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          PaymentMethodItem(
            title: 'Cash Payment',
            isSelected: seletecType == PaymentType.cash,
            type: PaymentType.cash,
          ),
          Space.y(10),
          PaymentMethodItem(
            title: 'Razorpay',
            isSelected: seletecType == PaymentType.razorpay,
            type: PaymentType.razorpay,
          ),
          Space.y(10),
          PaymentMethodItem(
            title: 'Credit Card',
            isSelected: seletecType == PaymentType.card,
            type: PaymentType.card,
          ),
        ],
      ),
    );
  }
}
