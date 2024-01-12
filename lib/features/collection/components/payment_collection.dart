import 'package:drmohans_homecare_flutter/common/widgets/bottom_sheet.dart';
import 'package:drmohans_homecare_flutter/common/widgets/error_snack_bar.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/collection_api_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/export_collection_controllers.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/payment_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/razorpay_link_sent.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/text_editig_controllers.dart';
import 'package:drmohans_homecare_flutter/features/collection/screens/payment_success.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/models/get_order_details_model.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../common/widgets/main_green_button.dart';
import '../../../common/widgets/space.dart';
import '../widgets/export_collection_widgets.dart';

final commentProvider = StateProvider<String>((ref) {
  return '';
});

class PaymentCollection extends ConsumerWidget {
  final GetOrderDetails orderDetails;
  const PaymentCollection(this.orderDetails, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = ref.read(textControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment collection',
          style: mon16BlackSB,
        ),
        Space.y(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Subtotal',
            ),
            Text(
              orderDetails.grossAmount,
              style: mon16BlackSB,
            )
          ],
        ),
        Space.y(10),
        Row(
          children: [
            const Text('Discount'),
            Space.x(5),
            const Icon(
              Icons.percent,
              color: HcTheme.greenColor,
              size: 16,
            ),
            const Spacer(),
            Text(
              orderDetails.discount,
              style: mon16GreenSB,
            )
          ],
        ),
        Space.y(10),
        const Divider(
          thickness: 1,
          color: HcTheme.lightGrey1Color,
        ),
        Space.y(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Payable',
              style: mon16BlackSB,
            ),
            Text(
              orderDetails.netAmount,
              style: mon16GreenSB,
            )
          ],
        ),
        Space.y(10),
        const Divider(
          thickness: 1,
          color: HcTheme.lightGrey1Color,
        ),
        Space.y(10),
        const Text(
          'Mode of payment',
          style: mon16BlackSB,
        ),
        const PaymentMethods(),
        Space.y(10),
        Consumer(
          builder: (context, ref, child) {
            final paymentMethod = ref.watch(paymentMethodSelectProvider);
            return Visibility(
              visible: paymentMethod == PaymentType.razorpay,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add mobile number',
                    style: mon16BlackSB,
                  ),
                  Space.y(10),
                  TextFormField(
                    maxLength: 10,
                    controller: textController.phoneController,
                    decoration: InputDecoration(
                      prefixText: '+91 ',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Space.y(10),
        Consumer(
          builder: (context, ref, _) {
            final paymentMethod = ref.watch(paymentMethodSelectProvider);
            final razorLinkSent = ref.watch(razorpayLinkSentProvider);
            return Visibility(
              visible: ((paymentMethod != PaymentType.razorpay) ||
                  ((paymentMethod == PaymentType.razorpay) && razorLinkSent)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Comments',
                    style: mon16BlackSB,
                  ),
                  Space.y(10),
                  TextField(
                    onChanged: (value) {
                      ref.read(commentProvider.notifier).state = value;
                    },
                    controller: textController.commmentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7))),
                  ),
                  Space.y(10),
                ],
              ),
            );
          },
        ),
        Consumer(
          builder: (context, ref, child) {
            final paymentMethod = ref.watch(paymentMethodSelectProvider);
            final razorLinkSent = ref.watch(razorpayLinkSentProvider);

            return MainGreenButton(
              title: (paymentMethod != PaymentType.razorpay || razorLinkSent)
                  ? 'PROCEED'
                  : "SEND RAZORPAY LINK",
              onPressed: () {
                if (paymentMethod != null) {
                  _buttonAction(
                    ref: ref,
                    context: context,
                    // orderId: "5596"
                    orderId: orderDetails.orderId,
                  );
                } else {
                  showErrorSnackBar(
                      context: context, errMsg: "Please select payment method");
                }
                ;
              },
              isLoading: false,
            );
          },
        )
      ],
    );
  }

  void _buttonAction({
    required WidgetRef ref,
    required BuildContext context,
    required String orderId,
  }) {
    final paymentMethod = ref.watch(paymentMethodSelectProvider);
    final razorLinkSent = ref.watch(razorpayLinkSentProvider);
    final textController = ref.read(textControllerProvider);
    final comment = ref.watch(commentProvider);
    ref.read(buttonLoadingController.notifier).state = true;
    if (paymentMethod != PaymentType.razorpay || razorLinkSent) {
      showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            ),
          ),
          builder: (BuildContext context) {
            return ConfirmationSheet(
                isLoading: ref.watch(buttonLoadingController),
                greenButtonPressed: () {
                  ref
                      .read(paymentController.notifier)
                      .payment(
                        orderId: orderId,
                        payMode: paymentMethod == PaymentType.razorpay
                            ? "Razorpay"
                            : paymentMethod == PaymentType.card
                                ? "Card"
                                : "Cash",
                        desc: textController.commmentController.text.trim(),
                      )
                      .then((result) {
                    if (result == "Success") {
                      ref.read(buttonLoadingController.notifier).state = false;
                      ref.read(razorpayLinkSentProvider.notifier).state = false;
                      textController.clear();
                      ref.invalidate(commentProvider);

                      // pushNewScreen(context,
                      //     screen: PaymentSuccessScreen(
                      //         description: comment.isNotEmpty ? comment : 'NA',
                      //         orderDetails: orderDetails));
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PaymentSuccessScreen(
                          // description: textController
                          //         .commmentController.text.isNotEmpty
                          //     ? textController.commmentController.text
                          //     : 'NA'
                          description: comment.isNotEmpty ? comment : 'NA',
                          orderDetails: orderDetails,
                        ),
                      ));
                      textController.commmentController.clear();
                    } else {
                      ref.read(buttonLoadingController.notifier).state = false;
                      showErrorSnackBar(
                          context: context, errMsg: "Failed to update payment");
                    }
                  });
                },
                whiteButtononPressed: () {
                  Navigator.pop(context);
                },
                title: 'Are you sure that payment is completed ?',
                whiteButtonText: 'Cancel',
                greenButtonText: 'Proceed');
          });
    } else {
      if (textController.phoneController.text.isNotEmpty) {
        ref
            .read(paymentController.notifier)
            .sendRazorpayLink(
                orderId: orderId,
                mobile: textController.phoneController.text.trim())
            .then((result) {
          if (result == "Success") {
            ref.read(buttonLoadingController.notifier).state = false;
            ref.read(razorpayLinkSentProvider.notifier).state = true;
          } else {
            ref.read(buttonLoadingController.notifier).state = false;
            showErrorSnackBar(
                context: context, errMsg: "Failed to sent Razorpay link");
          }
        });
      } else {
        ref.read(buttonLoadingController.notifier).state = false;
        showErrorSnackBar(context: context, errMsg: "Please fill phone number");
      }
    }
  }
}
