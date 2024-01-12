import 'package:drmohans_homecare_flutter/common/widgets/error_snack_bar.dart';
import 'package:drmohans_homecare_flutter/common/widgets/space.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/collection_api_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/widgets/check_progress_indicator.dart';
import 'package:drmohans_homecare_flutter/features/collection/widgets/customer_details_card.dart';
import 'package:drmohans_homecare_flutter/features/collection/components/mark_the_item_delivered.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/delivery_step_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/home_filter_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/models/get_order_details_model.dart';
import 'package:drmohans_homecare_flutter/features/delivery/controller/location_reached_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/collection_or_delivery_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/rides_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/tab_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/helper_fuctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/bottom_sheet.dart';
import '../../../common/widgets/main_appbar.dart';
import '../../../common/widgets/main_green_button.dart';
import '../../dashboard/controller/ride_status_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../components/export_components.dart';

class DeliveryStepScreen extends ConsumerWidget with HelperFunctions {
  final GetOrderDetails data;
  static int deliverStepCount = 0;
  const DeliveryStepScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;

    // List<Widget> sections = [
    //   const MarkTheItemDelivered(),
    //   PaymentCollection(data)
    // ];
    return Scaffold(
      appBar: MainAppbar(
          onBackButtonPressed: () {
            ref.invalidate(itemCountProvider);
            ref.read(deliveryStepController.notifier).state = 0;
            Navigator.of(context).pop();
          },
          title: 'My Rides'),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 115,
              color: HcTheme.blueColor,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                    width: size.width,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Ride ID ",
                        style: mon16White600,
                      ),
                      Text(
                        "#${data.orderId} ",
                        style: mon16lightGreenSB,
                      ),
                    ],
                  ),
                  Space.y(30),
                  CustomerDetailsCard(
                    address: data.address,
                    age: data.age,
                    gender: data.gender,
                    mobile: data.mobile,
                    mrn: data.mrn,
                    name: data.name,
                    photoUrl: data.photoUrl,
                  ),
                  Space.y(30),
                  _buildDeliverySteps(),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Consumer(
      //   builder: (context, ref, child) {
      //     final index = ref.watch(deliveryStepController);

      //     final itemCount = ref.watch(itemCountProvider);
      //     return Visibility(
      //       visible: index == 0,
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 10),
      //         child: MainGreenButton(
      //           title: 'PROCEED',
      //           onPressed: () {
      //             if (itemCount == 0) {
      //               showErrorSnackBar(
      //                 context: context,
      //                 errMsg: 'None of the Item is selected',
      //               );
      //             } else {
      //               ref
      //                   .read(collectionApiStateProvider.notifier)
      //                   .serviceUpdate(dataList: listVal, orderId: data.orderId)
      //                   .then((value) {
      //                 ref.read(deliveryItemProvider.notifier).state = [];
      //                 if (value == 'Success') {
      //                   final index =
      //                       ref.read(deliveryStepController.notifier).state;

      //                   if (index < DeliveryStepScreen.deliverStepCount - 1) {
      //                     ref.read(deliveryStepController.notifier).state++;
      //                   } else {
      //                     final profileData = ref.watch(profileProvider);
      //                     showModalBottomSheet(
      //                       context: context,
      //                       builder: (context) => SuccessFailedBottomSheet(
      //                         isSuccess: true,
      //                         title: "Ride completed",
      //                         buttonText: "Show next rides",
      //                         onPressed: () async {
      //                           ref.read(isButtonLoading.notifier).state = true;
      //                           List<String> dataList = [
      //                             data.orderId,
      //                             data.address,
      //                             // data.lat,
      //                             // data.lng,
      //                             '1'
      //                           ];
      //                           await ref
      //                               .read(
      //                                   rideStatusController(dataList).notifier)
      //                               .changeRideStatus();

      //                           ref.read(dashboardProvider.notifier).init(
      //                               fromDate: selectedDate["FromDate"]!,
      //                               toDate: selectedDate['ToDate']!);

      //                           ref.read(ridesProvider.notifier).getRides(
      //                                 fromDate: selectedDate["FromDate"]!,
      //                                 toDate: selectedDate["ToDate"]!,
      //                                 hcStatus: 0,
      //                                 type: 'All',
      //                               );

      //                           ref.invalidate(myRidesScreenTabController);
      //                           ref.invalidate(collectionOrDeliveryController);

      //                           if (!context.mounted) return;
      //                           ref.read(isButtonLoading.notifier).state =
      //                               false;
      //                           Navigator.popUntil(
      //                               context, (route) => route.isFirst);
      //                         },
      //                         content:
      //                             "Good job ${(profileData is ProfileSuccess) ? profileData.profileData.empName : "User"} , Your ride is completed",
      //                       ),
      //                     );
      //                     //TODO: show end
      //                   }
      //                 } else {
      //                   showErrorSnackBar(
      //                     context: context,
      //                     errMsg: 'Failed to submit data.',
      //                   );
      //                 }
      //               });
      //             }
      //           },
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }

  Consumer _buildDeliverySteps() {
    List<Widget> components = [];
    if (data.quesVisible) {
      components.add(QuestionsToAskComponent(
        isCollection: false,
        orderDetails: data,
      ));
    }
    if (data.serviceVIsible) {
      components.add(MarkTheItemDelivered(
        data: data,
      ));
    }
    if (data.payConfigVisible) {
      components.add(PaymentCollection(data));
    }

    return Consumer(
      builder: (context, ref, child) {
        final index = ref.watch(deliveryStepController);
        DeliveryStepScreen.deliverStepCount = components.length;
        return Column(
          children: [
            ProgressIndicatorAppointment(
              length: components.length,
              completeIndex: index,
            ),
            Space.y(10),
            components[index],
          ],
        );
      },
    );
  }
}
