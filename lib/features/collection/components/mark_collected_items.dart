import 'package:drmohans_homecare_flutter/features/collection/controllers/collection_api_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/export_collection_controllers.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/home_filter_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/collection_or_delivery_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/rides_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/tab_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/helper_fuctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/bottom_sheet.dart';
import '../../../common/widgets/error_snack_bar.dart';
import '../../../common/widgets/main_green_button.dart';
import '../../../common/widgets/space.dart';
import '../../dashboard/controller/ride_status_controller.dart';
import '../../dashboard/data/models/get_order_details_model.dart';
import '../../profile/controller/profile_controller.dart';
import '../screens/collection_steps_screen.dart';

class MarkCollectedItemsComponent extends ConsumerWidget with HelperFunctions {
  const MarkCollectedItemsComponent({super.key, required this.orderDetails});
  final GetOrderDetails orderDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterType = ref.watch(homeFilterProvider);
    final selectedDate = getFromAndToDate(filterType);

    List<Map<String, String>> dataList = List.generate(
        orderDetails.list.length,
        (index) => {
              "ServID": orderDetails.list[index].serviceId,
              "ServName": orderDetails.list[index].serviceName,
              "StsID": "0"
            });
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mark The Items That Are Collected',
            style: mon16BlackSB,
          ),
          Space.y(15),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              dataList.length,
              (index) => CheckBoxWithDescription(
                description: "${dataList[index]["ServName"]}",
                onChecked: (isChecked) {
                  if (isChecked) {
                    dataList[index]["StsID"] = "1";
                  } else {
                    dataList[index]["StsID"] = "0";
                  }
                },
              ),
            ),
          ),
          Space.y(30),
          MainGreenButton(
            isLoading: ref.watch(buttonLoadingController),
            title: 'Proceed',
            onPressed: () {
              bool atleaseOneSelected = false;
              for (var x in dataList) {
                if (x["StsID"] == "1") {
                  atleaseOneSelected = true;
                  break;
                }
              }
              if (atleaseOneSelected) {
                ref.read(buttonLoadingController.notifier).state = true;
                ref
                    .read(collectionApiStateProvider.notifier)
                    .serviceUpdate(
                      dataList: dataList,
                      orderId: orderDetails.orderId,
                    )
                    .then((resp) {
                  if (resp == "Success") {
                    ref.read(buttonLoadingController.notifier).state = false;
                    final index =
                        ref.read(collectionStepController.notifier).state;

                    if (index < CollectionStepsScreen.stepCount - 1) {
                      ref.read(collectionStepController.notifier).state++;
                    } else {
                      //TODO: edit if require
                      final profileData = ref.watch(profileProvider);
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SuccessFailedBottomSheet(
                          isSuccess: true,
                          title: "Ride completed",
                          buttonText: "Show next rides",
                          onPressed: () async {
                            List<String> dataList = [
                              orderDetails.orderId,
                              orderDetails.address,
                              // orderDetails.lat,
                              // orderDetails.lng,
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
                    ref.read(buttonLoadingController.notifier).state = false;
                    showErrorSnackBar(
                      context: context,
                      errMsg: 'Failed to submit data.',
                    );
                  }
                });
              } else {
                showErrorSnackBar(
                  context: context,
                  errMsg: 'Cannot proceed without selecting anything',
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class CheckBoxWithDescription extends StatelessWidget {
  const CheckBoxWithDescription({
    super.key,
    required this.description,
    required this.onChecked,
  });
  final String description;
  final Function(bool isChecked) onChecked;
  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> checked = ValueNotifier(false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ValueListenableBuilder(
          valueListenable: checked,
          builder: (context, isChecked, _) {
            return GestureDetector(
              onTap: () {
                checked.value = isChecked ? false : true;
                onChecked(isChecked ? false : true);
              },
              child: Row(
                children: [
                  Space.x(10),
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
                  Space.x(10),
                  Text(description)
                ],
              ),
            );
          }),
    );
  }
}
