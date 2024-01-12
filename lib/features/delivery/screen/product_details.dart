import 'package:drmohans_homecare_flutter/common/widgets/bottom_sheet.dart';
import 'package:drmohans_homecare_flutter/common/widgets/reschedule_cancel_bottomsheet.dart';
import 'package:drmohans_homecare_flutter/features/collection/components/mark_the_item_delivered.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/collection_api_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/screens/delivery_step_screen.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/ride_status_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/view_order_details_controller.dart';
import 'package:drmohans_homecare_flutter/features/delivery/controller/delivery_item_picked_controller.dart';
import 'package:drmohans_homecare_flutter/features/delivery/controller/location_reached_controller.dart';
import 'package:drmohans_homecare_flutter/features/delivery/widgets/product_data.dart';
import 'package:drmohans_homecare_flutter/features/delivery/widgets/user_greycard.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/collection_or_delivery_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/ride_details_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/rides_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/tab_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/helper_fuctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../common/widgets/main_appbar.dart';
import '../../../common/widgets/main_background.dart';
import '../../../common/widgets/main_green_button.dart';
import '../../../common/widgets/pricing.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/controller/home_filter_controller.dart';

class ProductDetailsPage extends ConsumerWidget with HelperFunctions {
  static const route = '/product-details';
  final String? orderId;
  final String? type;
  ProductDetailsPage({super.key, this.orderId, this.type});
  final List<String> orderData = [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    orderData.add(orderId ?? "");
    orderData.add(type ?? "");
    final rideDetailsController = ref.watch(orderDetailsController(orderData));
    // final reachedDes = ref.watch(locationReachedProvider);
    final reachWarehouse = ref.watch(pickupInitialedProvider);
    final filterType = ref.watch(homeFilterProvider);
    final selectedDate = getFromAndToDate(filterType);
    final loading = ref.watch(buttonLoading);
    // ref.read(deliveryItemProvider.notifier).state = [];
    return PopScope(
      onPopInvoked: (_) async {
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

        // return true;
      },
      child: Scaffold(
        appBar: MainAppbar(
          title: "My Rides",
          onBackButtonPressed: () {
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
            Navigator.pop(context);
          },
        ),
        body: SingleChildScrollView(
          child: MainBackgroundComponent(
              stops: const [0.2, 0.2],
              child: Column(
                children: [
                  if (rideDetailsController is OrderDetailsSuccess)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 7),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Ride ID',
                                      style: mon16WhiteSBold,
                                    ),
                                    Text(
                                      ' #${rideDetailsController.data.orderId}',
                                      style: mon16lightGreenSB,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              FutureBuilder(
                                  future: ref
                                      .read(collectionApiStateProvider.notifier)
                                      .getDistance(
                                          rideDetailsController.data.lat,
                                          rideDetailsController.data.lng),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.connectionState ==
                                            ConnectionState.done) {
                                      return GreyCardWithDetails(
                                        userName:
                                            rideDetailsController.data.name,
                                        mrnNumber:
                                            rideDetailsController.data.mrn,
                                        age: rideDetailsController.data.age,
                                        gender:
                                            rideDetailsController.data.gender,
                                        // warehoureAdrs:
                                        //     'Dr.Mohans Warehouse, Street 56, sec 12, Bengaluru,76890',
                                        userAdrs:
                                            rideDetailsController.data.address,
                                        timeInMins: (snapshot.hasData)
                                            ? (snapshot.data?[1])
                                            : 0,
                                        distance: (snapshot.hasData)
                                            ? (snapshot.data?[0])
                                            : 0,
                                        lat: rideDetailsController.data.lat,
                                        lng: rideDetailsController.data.lng,
                                        phone:
                                            rideDetailsController.data.mobile,
                                      );
                                    } else {
                                      return const CircularProgressIndicator(
                                        color: HcTheme.whiteColor,
                                      );
                                    }
                                  }),
                              const SizedBox(height: 16),
                              ProductData(
                                deliveryDate: DateFormat('dd MMM yyyy')
                                    .format(rideDetailsController.data.date),
                                deliveryTime:
                                    rideDetailsController.data.collDeliverTime,
                                // productName:
                                //     'Diabetic Footwear Slipper -Brown 6 cccccccccccccccccccccccc',
                                // quantity: 1,
                                pickedStatus:
                                    rideDetailsController.data.pickedStatus,
                                orderId: rideDetailsController.data.orderId,
                                productList: rideDetailsController.data.list,
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 0.2,
                          color: HcTheme.darkGrey2Color,
                        ),
                        Pricing(
                          price: "₹ ${rideDetailsController.data.grossAmount}",
                          discount:
                              '- ₹ ${rideDetailsController.data.discount}',
                          totalPay: '₹ ${rideDetailsController.data.netAmount}',
                        ),

                        if (rideDetailsController.data.pickedStatus == '' &&
                            reachWarehouse == false)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: MainGreenButton(
                              isLoading: loading,
                              title: 'PICKUP THE ITEM',
                              onPressed: () async {
                                ref.read(buttonLoading.notifier).state = true;
                                List<String> itemDetails = [];
                                itemDetails.add(orderId ?? '');
                                itemDetails
                                    .add(rideDetailsController.data.address);
                                itemDetails.add('0');

                                await ref
                                    .read(deliveryItemPickedController(
                                            itemDetails)
                                        .notifier)
                                    .updatePickStatus();
                                ref
                                    .read(pickupInitialedProvider.notifier)
                                    .state = true;

                                await ref
                                    .read(orderDetailsController(orderData)
                                        .notifier)
                                    .getOrderDetails()
                                    .then((value) {
                                  ref.read(buttonLoading.notifier).state =
                                      false;
                                });
                              },
                              textStyle: mon12White600,
                            ),
                          ),

                        if (rideDetailsController.data.pickedStatus == '' &&
                            reachWarehouse == true)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: MainGreenButton(
                              isLoading: loading,
                              title: 'REACHED WAREHOUSE, ITEM PICKED',
                              onPressed: () async {
                                ref.read(buttonLoading.notifier).state = true;

                                List<String> itemDetails = [];
                                itemDetails.add(orderId ?? '');
                                itemDetails
                                    .add(rideDetailsController.data.address);
                                itemDetails.add('1');
                                await ref
                                    .read(deliveryItemPickedController(
                                            itemDetails)
                                        .notifier)
                                    .updatePickStatus();
                                await ref
                                    .read(orderDetailsController(orderData)
                                        .notifier)
                                    .getOrderDetails()
                                    .then((value) {
                                  ref.read(buttonLoading.notifier).state =
                                      false;
                                });
                              },
                              textStyle: mon12White600,
                            ),
                          ),
                        // if (rideDetailsController.data.pickedStatus ==
                        //     'Reached Warehouse,Item picked')

                        if (rideDetailsController.data.pickedStatus ==
                                'Item Picked' &&
                            rideDetailsController.data.rideStatus ==
                                'Ride Pending')
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: MainGreenButton(
                                title: 'START RIDE',
                                onPressed: () {
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
                                          greenButtonPressed: () async {
                                            ref
                                                .read(isButtonLoading.notifier)
                                                .state = true;
                                            final ride =
                                                rideDetailsController.data;

                                            List<String> dataList = [
                                              ride.orderId,
                                              ride.address,
                                              '0'
                                            ];

                                            await ref
                                                .read(rideStatusController(
                                                        dataList)
                                                    .notifier)
                                                .changeRideStatus()
                                                .then((value) => Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () => ref
                                                        .read(
                                                            orderDetailsController(
                                                                    orderData)
                                                                .notifier)
                                                        .getOrderDetails()));
                                            ref
                                                .read(isButtonLoading.notifier)
                                                .state = false;

                                            // ref
                                            //     .read(locationReachedProvider
                                            //         .notifier)
                                            //     .state = true;

                                            // await ref
                                            //     .read(orderDetailsController(
                                            //             orderData)
                                            //         .notifier)
                                            //     .getOrderDetails();

                                            if (!context.mounted) return;
                                            Navigator.pop(context);
                                          },
                                          whiteButtononPressed: () {
                                            ref
                                                .read(isButtonLoading.notifier)
                                                .state = false;
                                            Navigator.pop(context);
                                          },
                                          title: 'Ready to start the ride?',
                                          whiteButtonText: 'CANCEL',
                                          greenButtonText: 'CONFIRM, START',
                                          isLoading: true,
                                        );
                                      });
                                },
                              )),
                        // if (reachedDes == true)

                        if (rideDetailsController.data.rideStatus ==
                            'Ride Started')
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: MainGreenButton(
                                  title: 'I HAVE REACHED THE LOCATION',
                                  onPressed: () {
                                    final ride = rideDetailsController.data;
                                    List<String> dataList = [
                                      ride.orderId,
                                      ride.address,
                                      '2'
                                    ];

                                    ref.read(rideStatusController(dataList));

                                    ref.read(deliveryItemProvider.notifier).state =
                                        List.generate(
                                            rideDetailsController
                                                .data.list.length,
                                            (index) => {
                                                  "ServID":
                                                      rideDetailsController
                                                          .data
                                                          .list[index]
                                                          .serviceId,
                                                  "ServName":
                                                      rideDetailsController
                                                          .data
                                                          .list[index]
                                                          .serviceName,
                                                  "StsID": "0"
                                                });

                                    ref
                                        .read(orderDetailsController(orderData)
                                            .notifier)
                                        .getOrderDetails();

                                    pushNewScreen(context,
                                        screen: DeliveryStepScreen(
                                          data: rideDetailsController.data,
                                        ));
                                    ref
                                        .read(rideDetailsProvider.notifier)
                                        .state = {
                                      "amount": ride.netAmount,
                                      "date": DateFormat('dd MMM yyyy')
                                          .format(ride.date),
                                      "time": DateFormat('hh : mm a')
                                          .format(ride.collDeliverTime),
                                      "name": ride.name,
                                      "mrn": ride.mrn,
                                      "age": ride.age,
                                      "gender": ride.gender
                                    };
                                  })),
                        if (rideDetailsController.data.rideStatus ==
                            'Location Reached')
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: MainGreenButton(
                                  title: 'PROCEED',
                                  onPressed: () {
                                    final ride = rideDetailsController.data;
                                    // List<String> dataList = [
                                    //   ride.orderId,
                                    //   ride.address,
                                    //   ride.lat,
                                    //   ride.lng,
                                    //   '2'
                                    // ];

                                    // ref.read(rideStatusController(dataList));

                                    ref.read(deliveryItemProvider.notifier).state =
                                        List.generate(
                                            ride.list.length,
                                            (index) => {
                                                  "ServID": ride
                                                      .list[index].serviceId,
                                                  "ServName": ride
                                                      .list[index].serviceName,
                                                  "StsID": "0"
                                                });

                                    pushNewScreen(context,
                                        screen: DeliveryStepScreen(
                                          data: rideDetailsController.data,
                                        ));
                                    print(
                                        "-------------------------------------------?");
                                    ref
                                        .read(rideDetailsProvider.notifier)
                                        .state = {
                                      "amount": ride.netAmount,
                                      "date": DateFormat('dd MMM yyyy')
                                          .format(ride.date),
                                      "time": DateFormat('hh : mm a')
                                          .format(ride.collDeliverTime),
                                      "name": ride.name,
                                      "mrn": ride.mrn,
                                      "age": ride.age,
                                      "gender": ride.gender
                                    };
                                  })),
                        if (rideDetailsController.data.rideStatus ==
                            'Ride Pending')
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 8, 12, 0),
                            child: MainGreenButton(
                              title: 'CANCEL / RESCHEDULE RIDE',
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        topLeft: Radius.circular(12),
                                      ),
                                    ),
                                    builder: (BuildContext context) {
                                      final rideData =
                                          rideDetailsController.data;
                                      return RescheduleCancelButtomSheet(
                                        rideData.orderId,
                                        rideData.address,
                                      );
                                    });
                              },
                              textStyle: mon12Green,
                              outlined: true,
                            ),
                          ),
                      ],
                    ),
                  if (rideDetailsController is OrderDetailsLoading ||
                      rideDetailsController is OrderDetailsError)
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                ],
              )),
        ),
      ),
    );
  }
}

final buttonLoading = StateProvider((ref) => false);
