import 'package:drmohans_homecare_flutter/features/dashboard/data/models/get_order_details_model.dart';
import 'package:drmohans_homecare_flutter/features/delivery/controller/location_reached_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/helper_fuctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/bottom_sheet.dart';
import '../../../common/widgets/error_snack_bar.dart';
import '../../../common/widgets/main_green_button.dart';
import '../../../common/widgets/space.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/controller/home_filter_controller.dart';
import '../../dashboard/controller/ride_status_controller.dart';
import '../../my_rides/controllers/collection_or_delivery_controller.dart';
import '../../my_rides/controllers/rides_controller.dart';
import '../../my_rides/controllers/tab_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../controllers/collection_api_controller.dart';
import '../controllers/delivery_step_controller.dart';
import '../screens/delivery_step_screen.dart';

final deliveryItemProvider = StateProvider<List<Map<String, String>>>((ref) {
  return [];
});

class MarkTheItemDelivered extends ConsumerWidget with HelperFunctions {
  final GetOrderDetails data;
  // final List<ListElement> list;
  const MarkTheItemDelivered({super.key, required this.data
      // required this.list
      });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listVal = ref.watch(deliveryItemProvider);
    final filterType = ref.watch(homeFilterProvider);
    final selectedDate = getFromAndToDate(filterType);

    // Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mark the items delivered',
          style: mon16BlackSB,
        ),
        Space.y(20),
        ...listVal.map((e) => DeliveryItems(
            onChecked: (isChecked) {
              if (isChecked) {
                e['StsID'] = '1';
                ref.read(itemCountProvider.notifier).state++;
              } else {
                e['StsID'] = '0';
                ref.read(itemCountProvider.notifier).state++;
              }
            },
            id: e['ServID']!,
            productName: e['ServName']!)),
        Space.y(20),
        Consumer(builder: (context, ref, _) {
          final itemCount = ref.watch(itemCountProvider);

          return MainGreenButton(
            title: 'Proceed',
            onPressed: () {
              if (itemCount == 0) {
                showErrorSnackBar(
                  context: context,
                  errMsg: 'None of the Item is selected',
                );
              } else {
                ref
                    .read(collectionApiStateProvider.notifier)
                    .serviceUpdate(dataList: listVal, orderId: data.orderId)
                    .then((value) {
                  ref.read(deliveryItemProvider.notifier).state = [];
                  if (value == 'Success') {
                    final index =
                        ref.read(deliveryStepController.notifier).state;

                    if (index < DeliveryStepScreen.deliverStepCount - 1) {
                      ref.read(deliveryStepController.notifier).state++;
                    } else {
                      final profileData = ref.watch(profileProvider);
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SuccessFailedBottomSheet(
                          isSuccess: true,
                          title: "Ride completed",
                          buttonText: "Show next rides",
                          onPressed: () async {
                            ref.read(isButtonLoading.notifier).state = true;
                            List<String> dataList = [
                              data.orderId,
                              data.address,
                              // data.lat,
                              // data.lng,
                              '1'
                            ];
                            await ref
                                .read(rideStatusController(dataList).notifier)
                                .changeRideStatus();

                            ref.read(dashboardProvider.notifier).init(
                                fromDate: selectedDate["FromDate"]!,
                                toDate: selectedDate['ToDate']!);

                            ref.read(ridesProvider.notifier).getRides(
                                  fromDate: selectedDate["FromDate"]!,
                                  toDate: selectedDate["ToDate"]!,
                                  hcStatus: 0,
                                  type: 'All',
                                );

                            ref.invalidate(myRidesScreenTabController);
                            ref.invalidate(collectionOrDeliveryController);

                            if (!context.mounted) return;
                            ref.read(isButtonLoading.notifier).state = false;
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          content:
                              "Good job ${(profileData is ProfileSuccess) ? profileData.profileData.empName : "User"} , Your ride is completed",
                        ),
                      );
                      //TODO: show end
                    }
                  } else {
                    showErrorSnackBar(
                      context: context,
                      errMsg: 'Failed to submit data.',
                    );
                  }
                });
              }
            },
          );
        })
      ],
    );
  }
}

class DeliveryItems extends StatelessWidget {
  const DeliveryItems(
      {super.key,
      required this.id,
      required this.productName,
      required this.onChecked});
  final String id;
  final String productName;
  final Function(bool isChecked) onChecked;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> checked = ValueNotifier(false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 3.0,
        ),
        child: ValueListenableBuilder(
            valueListenable: checked,
            builder: (context, isChecked, _) {
              return GestureDetector(
                onTap: () {
                  checked.value = !isChecked;

                  onChecked(isChecked ? false : true);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                        color: isChecked
                            ? HcTheme.greenColor
                            : HcTheme.lightGrey2Color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: HcTheme.whiteColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID :  $id',
                            style: mon16BlackSB,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Name :  $productName',
                            style: mon14Black,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
