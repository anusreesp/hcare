import 'package:drmohans_homecare_flutter/common/widgets/space.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/collection_steps_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/widgets/check_progress_indicator.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/models/get_order_details_model.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/main_appbar.dart';
import '../components/export_components.dart';
import '../widgets/customer_details_card.dart';

class CollectionStepsScreen extends ConsumerWidget {
  const CollectionStepsScreen({super.key, required this.orderDetails});
  final GetOrderDetails orderDetails;
  static int stepCount = 0;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MainAppbar(
          onBackButtonPressed: () {
            ref.read(collectionStepController.notifier).state = 0;

            Navigator.of(context).pop();
          },
          title: 'My rides'),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              color: HcTheme.blueColor,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    width: size.width,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Ride ID ",
                        style: mon16White600,
                      ),
                      Text(
                        "#${orderDetails.orderId} ",
                        style: mon16lightGreenSB,
                      ),
                    ],
                  ),
                  Space.y(30),
                  CustomerDetailsCard(
                    address: orderDetails.address,
                    age: orderDetails.age,
                    gender: orderDetails.gender,
                    mobile: orderDetails.mobile,
                    mrn: orderDetails.mrn,
                    name: orderDetails.name,
                    photoUrl: orderDetails.photoUrl,
                  ),
                  Space.y(30),
                  _buildStepComponents(orderDetails),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Consumer(
      //   builder: (context, ref, child) {
      //     final index = ref.watch(collectionStepController);
      //     return Visibility(
      //       visible: index == 2,
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 10),
      //         child: MainGreenButton(
      //           title: 'Proceed',
      //           onPressed: () {
      //             if (index == 0) {
      //             } else {
      //               ref.read(collectionStepController.notifier).state = 3;
      //             }
      //           },
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }

  Widget _buildStepComponents(GetOrderDetails orderDetails) {
    List<Widget> components = [];
    if (orderDetails.vitalsVisible) {
      components.add(VitalMesurementComponent(
        orderDetails: orderDetails,
      ));
    }
    if (orderDetails.quesVisible) {
      components.add(QuestionsToAskComponent(
        isCollection: true,
        orderDetails: orderDetails,
      ));
    }
    if (orderDetails.serviceVIsible) {
      components.add(MarkCollectedItemsComponent(orderDetails: orderDetails));
    }
    if (orderDetails.payConfigVisible) {
      components.add(PaymentCollection(orderDetails));
    }
    return Consumer(
      builder: (context, ref, child) {
        final index = ref.watch(collectionStepController);
        CollectionStepsScreen.stepCount = components.length;
        return BodySection(
          componentsLength: components.length,
          index: index,
          child: components[index],
        );
      },
    );
  }
}

class BodySection extends StatelessWidget {
  const BodySection(
      {super.key,
      required this.componentsLength,
      required this.index,
      required this.child});

  final int componentsLength;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProgressIndicatorAppointment(
          length: componentsLength,
          completeIndex: index,
        ),
        Space.y(10),
        child
      ],
    );
  }
}
