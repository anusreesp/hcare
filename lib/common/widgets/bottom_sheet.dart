import 'package:drmohans_homecare_flutter/common/controller/time_controller.dart';
import 'package:drmohans_homecare_flutter/features/collection/controllers/collection_time_change_controlller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'main_green_button.dart';

class ActionOrCancelBottomSheet extends StatelessWidget {
  final String title, greenButtonText, whiteButtonText;
  final VoidCallback greenButtononPressed;
  final VoidCallback whiteButtononPressed;

  const ActionOrCancelBottomSheet(
      {super.key,
      required this.title,
      required this.greenButtonText,
      required this.whiteButtonText,
      required this.greenButtononPressed,
      required this.whiteButtononPressed});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      // height: size.height * 0.23,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: mon16BlackSB,
            ),
            const SizedBox(
              height: 22,
            ),
            MainGreenButton(
                title: greenButtonText, onPressed: greenButtononPressed),
            const SizedBox(
              height: 6,
            ),
            MainGreenButton(
              title: whiteButtonText,
              onPressed: whiteButtononPressed,
              outlined: true,
            )
          ],
        ),
      ),
    );
  }
}

class SuccessFailedBottomSheet extends StatelessWidget {
  final String title, content, buttonText;
  final VoidCallback onPressed;
  final double horizontalPadding;
  final String? locationDetails;
  final bool isSuccess;

  const SuccessFailedBottomSheet(
      {super.key,
      required this.title,
      required this.buttonText,
      required this.onPressed,
      required this.content,
      this.horizontalPadding = 42,
      this.locationDetails,
      this.isSuccess = true});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
        width: size.width,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                height: locationDetails == null ? 22 : 14,
              ),
              SvgPicture.asset(isSuccess == true
                  ? 'assets/icons/svg/successful_icon.svg'
                  : 'assets/icons/svg/failed_icon.svg'),
              const SizedBox(
                height: 24,
              ),
              Text(
                title,
                style: mon18BlackSB,
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: mon14lightGrey3,
                ),
              ),
              if (locationDetails != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (locationDetails != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: SvgPicture.asset(
                              'assets/icons/svg/location_icon.svg'),
                        ),
                      SizedBox(
                        width: size.width * 0.80,
                        child: Text(
                          locationDetails!,
                          style: mon12Black,
                        ),
                      )
                    ],
                  ),
                ),
              const SizedBox(
                height: 26,
              ),
              Consumer(
                builder: (context,ref,_) {
                  final isLoading = ref.watch(isButtonLoading);
                  if (isLoading == true) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return MainGreenButton(title: buttonText, onPressed: onPressed);
                }
              )
            ])));
  }
}

class PunchInScreen extends StatelessWidget {
  final VoidCallback onPressed;
  PunchInScreen({super.key, required this.onPressed});

  final List notes = [
    'Ensure good lighting on your face',
    'Remove your face mask',
    'Do not use photos / screenshots',
    'Look at the camera and click'
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      // height: size.height * 0.53,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(child: SvgPicture.asset('assets/icons/svg/punch_in.svg')),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Punch in',
              style: mon16BlackSB,
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: size.height * 0.165,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notes.length,
                  itemBuilder: (context, i) {
                    int count = i + 1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Text(
                        '$count) ${notes[i]}',
                        style: mon14darkGrey1,
                      ),
                    );
                  }),
            ),
            MainGreenButton(title: 'CLICK YOUR SELFIE', onPressed: onPressed)
          ],
        ),
      ),
    );
  }
}

class ConfirmationSheet extends StatelessWidget {
  final String title, whiteButtonText, greenButtonText;
  final VoidCallback greenButtonPressed;
  final VoidCallback whiteButtononPressed;
  final bool? isLoading;
  const ConfirmationSheet(
      {super.key,
      required this.greenButtonPressed,
      required this.whiteButtononPressed,
      required this.title,
      required this.whiteButtonText,
      required this.greenButtonText,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width,
        // height: size.height * 0.19,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    title,
                    style: mon16BlackSB,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: MainGreenButton(
                          title: whiteButtonText,
                          onPressed: whiteButtononPressed,
                          outlined: true,
                          iconName: whiteButtonText == 'RETAKE'
                              ? 'retake_icon'
                              : null,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Consumer(builder: (context, ref, _) {
                        final isLoading = ref.watch(isButtonLoading);
                        if (isLoading == true) {
                          return const Flexible(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Flexible(
                            child: MainGreenButton(
                                isLoading: isLoading,
                                title: greenButtonText,
                                onPressed: greenButtonPressed));
                      })
                    ],
                  )
                ])));
  }
}

class CollectionTimeBottomsheet extends StatelessWidget {
  final String orderId;
  const CollectionTimeBottomsheet({super.key, required this.orderId});

  @override
  Widget build(
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width,
        // height: size.height * 0.27,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'Set Collection Time',
                    style: mon16BlackSB,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  selectTime(context),
                  const SizedBox(
                    height: 24,
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      TimeOfDay initialTime = ref.watch(currentTimeProvider);

                      DateTime date = ref.watch(currentCollectionTimeProvider);

                      String dateString =
                          DateFormat('dd-MMM-yyyy').format(date);
                      return MainGreenButton(
                          title: 'OKAY',
                          onPressed: () {
                            ref.read(collectionTimeProvider.notifier).state =
                                // initialTime.format(context);
                                '$dateString ${initialTime.hour}: ${initialTime.minute}';

                            ref.read(updatedTimeController(orderId));
                            ref
                                    .read(finalCollectionTimeProvider.notifier)
                                    .state =
                                DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    initialTime.hour,
                                    initialTime.minute);
                            ref
                                .read(changedCollectionTimeProvider.notifier)
                                .state = initialTime.format(context);
                            Navigator.pop(context);
                          });
                    },
                  )
                ])));
  }

  Widget selectTime(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer(builder: (context, ref, child) {
      TimeOfDay initialTime = ref.watch(currentTimeProvider);
      return InkWell(
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: initialTime,
            );
            ref.read(currentTimeProvider.notifier).state = pickedTime!;
          },
          child: Container(
            height: size.height * 0.078,
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  width: 1,
                  color: HcTheme.darkGrey2Color,
                )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/svg/duration_icon.svg',
                    height: 26,
                    width: 26,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Select time',
                        style: mon12lightGrey3,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        // '12:00 PM',
                        initialTime.format(context),
                        style: mon16Black,
                      )
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    "assets/icons/svg/down_arrow.svg",
                    // width: 8,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
