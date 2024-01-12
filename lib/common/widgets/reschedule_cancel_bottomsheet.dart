import 'package:drmohans_homecare_flutter/common/controller/cancel_reschedule_controller.dart';
import 'package:drmohans_homecare_flutter/common/widgets/radiobutton_tile.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_trip_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/home_filter_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/helper_fuctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bottom_sheet.dart';
import 'main_green_button.dart';
import 'main_textfield.dart';

final isRescheduledProvider = StateProvider<bool>((ref) {
  return true;
});

final GlobalKey<FormState> reasonKey = GlobalKey<FormState>();

class RescheduleCancelButtomSheet extends ConsumerWidget with HelperFunctions {
  final String orderId, address;
  const RescheduleCancelButtomSheet(this.orderId, this.address, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final tripId = ref.watch(tripIdProvider);

    final isRescheduled = ref.watch(isRescheduledProvider);
    final largeText = ref.watch(largeTextProvider);

    return SizedBox(
        width: size.width,
        // height: size.height * 0.48,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
            child: Form(
              key: reasonKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text(
                  'You sure you want to?',
                  style: mon16BlackSB,
                ),
                const SizedBox(height: 16),
                RadioButtonTextTile(
                  title: 'Reschedule Trip',
                  value: isRescheduled == true ? true : false,
                  onTap: () {
                    ref.read(isRescheduledProvider.notifier).state = true;
                  },
                  onChanged: (bool) {
                    // ref.read(prescriptionIndexProvider.notifier).state = index;
                    // ref.read(isRescheduledProvider.notifier).state = true;
                  },
                ),
                const SizedBox(height: 4),
                RadioButtonTextTile(
                  title: 'Cancel Trip',
                  value: isRescheduled == true ? false : true,
                  onTap: () {
                    ref.read(isRescheduledProvider.notifier).state = false;
                  },
                  onChanged: (bool) {
                    // ref.read(prescriptionIndexProvider.notifier).state = index;
                    // ref.read(isRescheduledProvider.notifier).state = false;
                  },
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Reason',
                    style: mon14BlackSB,
                  ),
                ),
                const SizedBox(height: 8),
                LargeTextField(
                  hintText: 'the reason',
                  onChanged: (String str) {
                    ref.read(largeTextProvider.notifier).state = str;
                  },
                ),
                const SizedBox(height: 20),
                MainGreenButton(
                    title: 'PROCEED',
                    onPressed: () async {
                      if (reasonKey.currentState?.validate() ?? false) {
                        final status = isRescheduled ? '3' : '5';

                        List<String> dataList = [
                          orderId,
                          address,
                          // lat,
                          // lng,
                          status,
                          tripId,
                          largeText,
                        ];

                        ref.read(cancelDataListProvider.notifier).state =
                            dataList;

                        await ref
                            .read(cancelRescheduleProvider.notifier)
                            .cancelReschedule();

                        final filterType = ref.watch(homeFilterProvider);
                        final selectedDate = getFromAndToDate(filterType);
                        await ref.read(dashboardProvider.notifier).init(
                            fromDate: selectedDate["FromDate"]!,
                            toDate: selectedDate['ToDate']!);

                        if (!context.mounted) return;
                        Navigator.pop(context);

                        showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                topLeft: Radius.circular(12),
                              ),
                            ),
                            builder: (BuildContext context) {
                              //   return SuccessFailedBottomSheet(
                              //       title: 'Reschedule requested!',
                              //       buttonText: 'OKAY',
                              //       onPressed: () {
                              //         Navigator.pop(context);
                              //       },
                              //       content:
                              //           'Admin will reschedule this trip, wait until further notice');

                              return SuccessFailedBottomSheet(
                                  title: 'Trip Cancelled',
                                  buttonText: 'OKAY',
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  content:
                                      'This trip has been cancelled and assigned to someone else');
                            });
                      }
                    })
              ]),
            )));
  }
}
