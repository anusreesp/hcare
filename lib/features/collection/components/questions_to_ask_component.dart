import 'package:drmohans_homecare_flutter/common/widgets/error_snack_bar.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/collection_api_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/delivery_step_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/order_id_provider.dart';
import 'package:drmohans_homecare_flutter/features/collection/data/models/question_list_model/question_list_model.dart';
import 'package:drmohans_homecare_flutter/features/collection/screens/delivery_step_screen.dart';
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
import '../../../common/widgets/main_green_button.dart';
import '../../../common/widgets/space.dart';
import '../../dashboard/controller/ride_status_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../controllers/export_collection_controllers.dart';
import '../screens/collection_steps_screen.dart';
import '../widgets/export_collection_widgets.dart';

Map<String, dynamic> answerMap = {};

class QuestionsToAskComponent extends ConsumerWidget with HelperFunctions {
  const QuestionsToAskComponent(
      {super.key, required this.orderDetails, required this.isCollection});
  final GetOrderDetails orderDetails;
  final bool isCollection;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterType = ref.watch(homeFilterProvider);
    final selectedDate = getFromAndToDate(filterType);

    final orderId = ref.watch(orderIdProvider);
    ref.read(collectionApiStateProvider.notifier).getQuestions(
        orderId: orderId, hcType: isCollection ? "Collection" : "Delivery");
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Questions To Ask',
          style: mon16BlackSB,
        ),
        Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(collectionApiStateProvider);
            if (state is CollectionStepError) {
              return SizedBox(
                height: size.width,
                width: size.width,
                child: Center(
                  child: Text(state.errMsg),
                ),
              );
            }
            if (state is CollectionStepData) {
              QuestionListModel qlist = state.data;
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return QuestionWidget(
                        answer: (answer) {
                          // hcAnswers
                          //     .add({"QueID": "${index + 1}", "Ans": answer});
                          answerMap["${index + 1}"] = answer;
                        },
                        question: qlist.questions[index],
                      );
                    },
                    itemCount: qlist.questions.length,
                  ),
                  Space.y(10),
                  MainGreenButton(
                    title: 'Proceed',
                    onPressed: () {
                      List<Map<String, dynamic>> hcAnswers = [];
                      answerMap.forEach((key, value) {
                        hcAnswers.add({"QueID": key, "Ans": value});
                      });

                      if (hcAnswers.length < qlist.questions.length) {
                        showErrorSnackBar(
                            context: context,
                            errMsg: 'Please respond to all questions.');
                      } else {
                        ref.read(buttonLoadingController.notifier).state = true;
                        ref
                            .read(collectionApiStateProvider.notifier)
                            .submitAnswer(hcAnswers, orderId)
                            .then((resp) {
                          if (resp == "Success") {
                            ref.read(buttonLoadingController.notifier).state =
                                false;
                            final index = ref
                                .read(isCollection
                                    ? collectionStepController.notifier
                                    : deliveryStepController.notifier)
                                .state;
                            int count = isCollection
                                ? CollectionStepsScreen.stepCount - 1
                                : DeliveryStepScreen.deliverStepCount - 1;

                            if (index < count) {
                              hcAnswers.clear();
                              answerMap.clear();
                              ref
                                  .read(isCollection
                                      ? collectionStepController.notifier
                                      : deliveryStepController.notifier)
                                  .state++;
                            } else {
                              //TODO: Edit if require
                              final profileData = ref.watch(profileProvider);
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => SuccessFailedBottomSheet(
                                  isSuccess: true,
                                  title: "Ride completed",
                                  buttonText: "Show next rides",
                                  onPressed: () async {
                                    ref.read(isButtonLoading.notifier).state =
                                        true;
                                    List<String> dataList = [
                                      orderDetails.orderId,
                                      orderDetails.address,
                                      // orderDetails.lat,
                                      // orderDetails.lng,
                                      '1'
                                    ];
                                    await ref
                                        .read(rideStatusController(dataList)
                                            .notifier)
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
                                    ref.invalidate(
                                        collectionOrDeliveryController);

                                    if (!context.mounted) return;
                                    ref.read(isButtonLoading.notifier).state =
                                        false;
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
                            ref.read(buttonLoadingController.notifier).state =
                                false;
                            showErrorSnackBar(
                              context: context,
                              errMsg: 'Failed to submit answers.',
                            );
                          }
                        });
                      }
                    },
                    isLoading: ref.watch(buttonLoadingController),
                  )
                ],
              );
            }
            return SizedBox(
              height: size.width,
              width: size.width,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ],
    );
  }
}
