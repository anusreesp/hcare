import 'package:drmohans_homecare_flutter/features/collection/components/export_components.dart';
import 'package:drmohans_homecare_flutter/features/collection/widgets/patient_card_component.dart';
import 'package:drmohans_homecare_flutter/features/collection/widgets/payment_text_tile.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/home_filter_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/ride_status_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/models/get_order_details_model.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/collection_or_delivery_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/ride_details_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/rides_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/tab_controller.dart';
import 'package:drmohans_homecare_flutter/features/profile/controller/profile_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/helper_fuctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/bottom_sheet.dart';
import '../../../common/widgets/main_green_button.dart';
import '../controllers/payment_method_controller.dart';

class PaymentSuccessScreen extends ConsumerWidget with HelperFunctions {
  final String description;
  final GetOrderDetails orderDetails;
  const PaymentSuccessScreen(
      {Key? key, required this.description, required this.orderDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payment = ref.watch(paymentMethodSelectProvider);
    final data = ref.watch(rideDetailsProvider);
    final profileData = ref.watch(profileProvider);
    final filterType = ref.watch(homeFilterProvider);
    final selectedDate = getFromAndToDate(filterType);
    print(data);

    return PopScope(
      onPopInvoked: (_) {},
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: profileData is ProfileSuccess
              ? MainGreenButton(
                  title: "END RIDE",
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SuccessFailedBottomSheet(
                          isSuccess: true,
                          title: "Ride completed",
                          buttonText: "Show next rides",
                          onPressed: () async {
                            print("========================");
                            ref.read(isButtonLoading.notifier).state = true;
                            List<String> dataList = [
                              orderDetails.orderId,
                              orderDetails.address,
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
                            ref.read(isButtonLoading.notifier).state = false;
                            if (!context.mounted) return;
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          content:
                              "Good job ${profileData.profileData.empName} , Your ride is completed"),
                    );
                  })
              : const CircularProgressIndicator(),
        ),
        appBar: AppBar(
          title: const Text('Payment Confirmation'),
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     onPressed: () {
          //       Navigator.popUntil(context, (route) => route.isFirst);
          //     }),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(
                height: 36,
                width: double.infinity,
              ),
              SvgPicture.asset('assets/icons/svg/successful_icon.svg'),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Payment received",
                style: mon18BlackSB,
              ),
              const SizedBox(
                height: 12,
              ),
              PatientCardComponent(
                name: data['name'].toString(),
                age: data['age'].toString(),
                gender: data['gender'].toString(),
                mrn: data['mrn'].toString(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Payment details", style: mon16BlackSB)),
              const SizedBox(
                height: 12,
              ),
              Column(
                children: [
                  PaymentReceivedTextTile(
                      title: "Date", data: data['date'].toString()),
                  PaymentReceivedTextTile(
                      title: "Time", data: data['time'].toString()),
                  PaymentReceivedTextTile(
                      title: "Amount Collected",
                      data: data['amount'].toString()),
                  PaymentReceivedTextTile(
                      title: "Mode of payment",
                      data: payment == PaymentType.card
                          ? "Card"
                          : payment == PaymentType.cash
                              ? "Cash"
                              : "Razorpay"),
                  PaymentReceivedTextTile(
                      title: "Description",
                      data: description.isNotEmpty ? description : "NA"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
