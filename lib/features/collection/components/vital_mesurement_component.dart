import 'package:drmohans_homecare_flutter/features/collection/controllers/collection_api_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/collection_steps_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/text_editig_controllers.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/home_filter_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/models/get_order_details_model.dart';
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
import '../../../common/widgets/textfield_with_icon.dart';
import '../../dashboard/controller/ride_status_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../screens/collection_steps_screen.dart';

class VitalMesurementComponent extends ConsumerWidget with HelperFunctions {
  final GetOrderDetails orderDetails;

  const VitalMesurementComponent({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterType = ref.watch(homeFilterProvider);
    final selectedDate = getFromAndToDate(filterType);

    Size size = MediaQuery.of(context).size;
    final controllers = ref.read(textControllerProvider);

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vital Measurements Of The Patient",
            style: mon16BlackSB,
          ),
          Space.y(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFieldWithIcon(
                  controller: controllers.sysController,
                  height: size.height * 0.08,
                  width: size.width / 2.3,
                  hint: "Systolic mm/Hg",
                  icon: "assets/icons/svg/droplet.svg"),
              TextFieldWithIcon(
                  controller: controllers.diaController,
                  height: size.height * 0.08,
                  width: size.width / 2.3,
                  hint: "Diastolic mm/Hg",
                  icon: "assets/icons/svg/droplet.svg"),
            ],
          ),
          Space.y(10),
          Align(
              alignment: Alignment.center,
              child: TextFieldWithIcon(
                  controller: controllers.wController,
                  height: size.height * 0.08,
                  width: size.width / 1.12,
                  hint: "Enter body weight (kg)",
                  icon: "assets/icons/svg/weightscale.svg")),
          Space.y(10),
          Align(
            alignment: Alignment.center,
            child: TextFieldWithIcon(
                controller: controllers.hController,
                height: size.height * 0.08,
                width: size.width / 1.12,
                hint: "Enter Height (cm)",
                icon: "assets/icons/svg/height_meter.svg"),
          ),
          Space.y(20),
          MainGreenButton(
            title: 'Proceed',
            onPressed: () {
              if (controllers.sysController.text.isNotEmpty &&
                  controllers.diaController.text.isNotEmpty &&
                  controllers.hController.text.isNotEmpty &&
                  controllers.wController.text.isNotEmpty) {
                ref.read(buttonLoadingController.notifier).state = true;
                ref
                    .read(collectionApiStateProvider.notifier)
                    .vitalMesurementSubmit(
                      bPSys: controllers.sysController.text.trim(),
                      bpDia: controllers.diaController.text.trim(),
                      wt: controllers.wController.text.trim(),
                      ht: controllers.hController.text.trim(),
                      orderId: orderDetails.orderId,
                    )
                    .then((value) {
                  if (value == "Success") {
                    controllers.clear();
                    ref.read(buttonLoadingController.notifier).state = false;

                    final index =
                        ref.read(collectionStepController.notifier).state;

                    if (index < CollectionStepsScreen.stepCount - 1) {
                      ref.read(collectionStepController.notifier).state++;
                    } else {
                      //TODO: Edit if Require
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
                    ref.read(buttonLoadingController.notifier).state = false;
                    showErrorSnackBar(
                        context: context,
                        errMsg: "Failed to submit vital measurements");
                  }
                });
              } else {
                ref.read(buttonLoadingController.notifier).state = false;
                showErrorSnackBar(
                    context: context, errMsg: "Please fill all fields");
              }
            },
            isLoading: ref.watch(buttonLoadingController),
          )
        ],
      ),
    );
  }
}
