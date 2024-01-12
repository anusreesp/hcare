import 'package:drmohans_homecare_flutter/common/controller/time_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/collection_api_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/collection_steps_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/screens/collection_steps_screen.dart';
import 'package:drmohans_homecare_flutter/features/collection/widgets/grey_user_card.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/ride_status_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/view_order_details_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/models/get_order_details_model.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/ride_details_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/bottom_sheet.dart';
import '../../../common/widgets/icon_text.dart';
import '../../../common/widgets/main_appbar.dart';
import '../../../common/widgets/main_background.dart';
import '../../../common/widgets/main_green_button.dart';
import '../../../common/widgets/pricing.dart';
import '../../../common/widgets/reschedule_cancel_bottomsheet.dart';
import '../controllers/order_id_provider.dart';

class CollectionUserDetails extends ConsumerWidget {
  static const route = '/collection-user-details';
  final String? orderId;
  final String? type;

  CollectionUserDetails({super.key, this.orderId, this.type});
  List<String> orderData = [];

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    // final isStartRide = ref.watch(isRideStartProvider);
    // final isRideCompleted = ref.watch(isRideCompletedProvider);
    // final cancelReschedule = ref.watch(cancelOrRescheduledProvider);
    orderData.add(orderId ?? "");
    orderData.add(type ?? "");
    final rideDetails = ref.watch(orderDetailsController(orderData));
    // WidgetsBinding.instance.addPostFrameCallback((_) async{
    //   final data = await ref.read(collectionApiStateProvider.notifier).getDistance(13.05, 78.000);
    //   print("-------------===>>>$data");
    // });
    return Scaffold(
        appBar: MainAppbar(
          title: "My Rides",
          onBackButtonPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: SingleChildScrollView(
          child: MainBackgroundComponent(
              stops: const [0.2, 0.2],
              child: Column(
                children: [
                  if (rideDetails is OrderDetailsSuccess)
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 7),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Ride ID',
                                        style: mon16WhiteSBold,
                                      ),
                                      Text(
                                        ' #${rideDetails.data.orderId}',
                                        style: mon16lightGreenSB,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                FutureBuilder(
                                    future: ref
                                        .read(
                                            collectionApiStateProvider.notifier)
                                        .getDistance(rideDetails.data.lat,
                                            rideDetails.data.lng),
                                    builder: (context, snapshot) {
                                      // print(snapshot.data);
                                      if (snapshot.hasData &&
                                          snapshot.connectionState ==
                                              ConnectionState.done) {
                                        // ref
                                        //     .read(rideDistanceProvider.notifier)
                                        //     .state = snapshot.data?[0];
                                        return UserGreyCard(
                                          userName: rideDetails.data.name,
                                          mrnNumber: rideDetails.data.mrn,
                                          age: rideDetails.data.age,
                                          gender: rideDetails.data.gender,
                                          userAdrs: rideDetails.data.address,
                                          timeInMins: (snapshot.hasData)
                                              ? (snapshot.data?[1])
                                              : 0,
                                          distance: (snapshot.hasData)
                                              ? (snapshot.data?[0])
                                              : 0,
                                          lat: rideDetails.data.lat,
                                          lng: rideDetails.data.lng,
                                          phone: rideDetails.data.mobile,
                                        );
                                      } else {
                                        return const CircularProgressIndicator(
                                          color: HcTheme.whiteColor,
                                        );
                                      }
                                    }),
                                const SizedBox(height: 16),
                              ])),
                          ItemDetails(
                            grossAmt: rideDetails.data.grossAmount,
                            discount: rideDetails.data.discount,
                            totalAmt: rideDetails.data.netAmount,
                            collectionDate: DateFormat('dd MMM yyyy')
                                .format(rideDetails.data.date),
                            collectionTime:
                                //  DateFormat('hh:mm a')
                                //     .format(
                                rideDetails.data.collDeliverTime,
                            // ),
                            collectionDetails: rideDetails.data.list,
                            orderId: orderId!,
                            hcStatus: rideDetails.data.hcStatus,
                          ),
                          // if (isStartRide)
                          if (rideDetails.data.rideStatus == 'Ride Pending')
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
                                          ref
                                              .read(orderIdProvider.notifier)
                                              .state = orderId!;

                                          // ref
                                          //     .read(isRideCompletedProvider
                                          //         .notifier)
                                          //     .state = true;
                                          // ref
                                          //     .read(isRideStartProvider
                                          //         .notifier)
                                          //     .state = false;
                                          // ref
                                          //     .read(
                                          //         cancelOrRescheduledProvider
                                          //             .notifier)
                                          //     .state = false;

                                          ///----------------API part ------------------

                                          final ride = rideDetails.data;

                                          List<String> dataList = [
                                            ride.orderId,
                                            ride.address,
                                            '0'
                                          ];

                                          await ref
                                              .read(
                                                  rideStatusController(dataList)
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

                                          if (!context.mounted) return;
                                          Navigator.pop(context);

                                          // pushNewScreen(context,
                                          //     screen: CollectionUserDetails(
                                          //       orderId: orderId,
                                          //       type: type,
                                          //     ));
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
                                    },
                                  );
                                },
                                textStyle: mon12White600,
                              ),
                            ),
                          if (rideDetails.data.rideStatus == 'Ride Pending')
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: MainGreenButton(
                                title: 'CANCEL / RESCHEDULE RIDE',
                                onPressed: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          topLeft: Radius.circular(12),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        // ref
                                        //     .read(cancelOrRescheduledProvider
                                        //         .notifier)
                                        //     .state = false;
                                        final rideData = rideDetails.data;
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
                          // if (isRideCompleted)
                          if (rideDetails.data.rideStatus == 'Ride Started')
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: MainGreenButton(
                                  title: 'I REACHED THE LOCATION',
                                  onPressed: () {
                                    final ride = rideDetails.data;
                                    List<String> dataList = [
                                      ride.orderId,
                                      ride.address,
                                      '2'
                                    ];

                                    ref.read(rideStatusController(dataList));

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          CollectionStepsScreen(
                                              orderDetails: rideDetails.data),
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
                                  },
                                )),

                          if (rideDetails.data.rideStatus == 'Location Reached')
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: MainGreenButton(
                                  title: 'PROCEED',
                                  onPressed: () {
                                    final ride = rideDetails.data;
                                    List<String> dataList = [
                                      ride.orderId,
                                      ride.address,
                                      '2'
                                    ];

                                    ref.read(rideStatusController(dataList));
                                    if ((!rideDetails.data.vitalsVisible) &&
                                        (!rideDetails.data.quesVisible) &&
                                        (!rideDetails.data.serviceVIsible) &&
                                        (!rideDetails.data.payConfigVisible)) {
                                      // ref
                                      //     .read(
                                      //         collectionStepController.notifier)
                                      //     .state = 1;
                                    }
                                    ref
                                        .read(collectionStepController.notifier)
                                        .state = 0;
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          CollectionStepsScreen(
                                              orderDetails: rideDetails.data),
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
                                  },
                                ))
                        ]),
                  if (rideDetails is OrderDetailsLoading ||
                      rideDetails is OrderDetailsError)
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                ],
              )),
        ));
  }
}

class ItemDetails extends StatelessWidget {
  final String collectionDate;
  final DateTime collectionTime;
  final List<ListElement> collectionDetails;
  final String? totalAmt;
  final String? grossAmt;
  final String? discount;
  final String orderId;
  final String hcStatus;
  const ItemDetails(
      {super.key,
      required this.collectionDate,
      required this.collectionTime,
      required this.collectionDetails,
      this.totalAmt,
      this.grossAmt,
      this.discount,
      required this.orderId,
      required this.hcStatus});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Collection Date",
                  style: mon16BlackSB,
                ),
                const SizedBox(height: 8),
                IconText(
                    iconPath: 'calendar_icon',
                    iconColor: HcTheme.blueColor,
                    iconHeight: 14,
                    title: collectionDate.toString(),
                    style: mon14Black)
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Collection Time",
                  style: mon16BlackSB,
                ),
                const SizedBox(height: 8),
                Consumer(builder: (context, ref, child) {
                  final finalController =
                      ref.watch(finalCollectionTimeProvider);
                  final changedController =
                      ref.watch(changedCollectionTimeProvider);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconText(
                          iconPath: 'duration_icon',
                          iconColor: HcTheme.blueColor,
                          iconHeight: 15,
                          title:
                              // collectionTime.toString(),
                              changedController.isEmpty
                                  ? DateFormat('hh:mm a').format(collectionTime)
                                  : changedController,
                          style: mon14Black),
                      // Visibility(
                      //   visible: hcStatus == 'Unscheduled',
                      //   child:
                      InkWell(
                        onTap: () {
                          final DateTime collTime;

                          if (finalController == null) {
                            collTime = collectionTime;
                          } else {
                            collTime = finalController;
                          }

                          ref.read(currentTimeProvider.notifier).state =
                              TimeOfDay.fromDateTime(collTime);

                          ref
                              .read(currentCollectionTimeProvider.notifier)
                              .state = collTime;

                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  topLeft: Radius.circular(12),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return CollectionTimeBottomsheet(
                                  orderId: orderId,
                                );
                              });
                        },
                        child: Text(
                          'Edit',
                          style: mon14Blue.merge(const TextStyle(
                              decoration: TextDecoration.underline)),
                        ),
                      ),
                      // )
                    ],
                  );
                })
              ],
            )
          ],
        ),
      ),
      const SizedBox(height: 24),
      const Divider(
        thickness: 0.1,
        height: 5,
        color: HcTheme.darkGrey2Color,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(
          14.0,
          14.0,
          14.0,
          6.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Collection Details',
              style: mon16BlackSB,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: collectionDetails.length * 32,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: collectionDetails.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: IconText(
                          iconPath: 'tick',
                          title: collectionDetails[index].serviceName,
                          style: mon14Black),
                    );
                  }),
            )
          ],
        ),
      ),
      const Divider(
        thickness: 0.1,
        height: 5,
        color: HcTheme.darkGrey2Color,
      ),
      Pricing(
        price: '₹ $grossAmt',
        discount: '- ₹ $discount',
        totalPay: '₹ $totalAmt',
      ),
    ]));
  }
}
