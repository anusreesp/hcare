import 'dart:io';

import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/helper_fuctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/bottom_sheet.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/home_filter_controller.dart';

class PhotoScreen extends StatelessWidget with HelperFunctions {
  const PhotoScreen({super.key, required this.image});
  final XFile image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
              child: Image.file(
                File(image.path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: HcTheme.whiteColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Consumer(builder: (context, ref, _) {
                        final filterType = ref.watch(homeFilterProvider);
                        final selectedDate = getFromAndToDate(filterType);
                        DateTime dateTime = DateTime.now();
                        String time = DateFormat('hh:mm a').format(dateTime);
                        return ConfirmationSheet(
                            greenButtonPressed: () async {
                              ref.read(isButtonLoading.notifier).state = true;
                              print("------------------------------   1");
                              await ref
                                  .read(dashboardProvider.notifier)
                                  .punchIn(
                                    File(image.path),
                                  )
                                  .then((value) {
                                Navigator.pop(context);
                                showModalBottomSheet(
                                  context: context,
                                  builder: (ctx) => SuccessFailedBottomSheet(
                                      locationDetails: value ?? "",
                                      title: 'You are set to go!',
                                      buttonText: 'GO TO TRIPS',
                                      onPressed: () async {
                                        Navigator.of(ctx).pop();
                                        await ref
                                            .read(dashboardProvider.notifier)
                                            .init(
                                                fromDate: selectedDate["FromDate"]!,
                                                toDate: selectedDate['ToDate']!);
                                      },
                                      content: "You punched in at $time"),
                                );
                              });
                              final LocationPermission permission = await Geolocator.checkPermission();
                              if(permission == LocationPermission.values || permission == LocationPermission.whileInUse){
                                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                              }
                              ref.read(isButtonLoading.notifier).state = false;
                            },
                            whiteButtononPressed: () {
                              Navigator.pop(context);
                              ref.read(isButtonLoading.notifier).state = false;
                            },
                            title: 'Looks good',
                            whiteButtonText: 'RETAKE',
                            greenButtonText: 'UPLOAD');
                      }),
                    ),

            )
          ],
        ),
      ),
    );
  }
}
