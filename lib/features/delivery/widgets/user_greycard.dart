import 'package:drmohans_homecare_flutter/common/controller/punch_in_function.dart';
import 'package:drmohans_homecare_flutter/features/profile/controller/profile_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/helper_fuctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/widgets/grey_container.dart';
import '../../../common/widgets/icon_text.dart';
import '../../../common/widgets/location_steps.dart';

class GreyCardWithDetails extends StatelessWidget with HelperFunctions {
  final String userName,
      gender,
      // warehoureAdrs,
      userAdrs,
      mrnNumber,
      age,
      phone,
      lat,
      lng;
  final int timeInMins;
  final int distance;
  const GreyCardWithDetails({
    super.key,
    required this.userName,
    required this.gender,
    // required this.warehoureAdrs,
    required this.userAdrs,
    required this.mrnNumber,
    required this.age,
    required this.timeInMins,
    required this.distance,
    required this.lat,
    required this.lng,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GreyCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      borderRadius: 4,
      child: SizedBox(
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/avatar/svg/user_man1.svg'),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SvgPicture.asset('assets/avatar/svg/user_man1.svg'),
                      // const SizedBox(
                      //   width: 16,
                      // ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: mon14BlackSB,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "MRN: $mrnNumber | $age, $gender",
                              style: mon12lightGrey3,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const LocationThreeSteps(
                                  isThreeLocation: false,
                                ),
                                SizedBox(
                                  width: size.width * 0.53,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Your Location",
                                        style: mon12BlackMedium,
                                      ),
                                      // const SizedBox(
                                      //   height: 12,
                                      // ),
                                      // Text(
                                      //   warehoureAdrs,
                                      //   style: mon12BlackMedium,
                                      // ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        userAdrs,
                                        style: mon12BlackMedium,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Consumer(builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        final isPunched = ref.watch(isPunchedIn);

                        return InkWell(
                          onTap: () async {
                            if (isPunched == true) {
                              await dialPhoneNumber(phone);
                            } else {
                              punchIn(context);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0, right: 4),
                            child: SizedBox(
                              child: SvgPicture.asset(
                                'assets/icons/svg/green_phone.svg',
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                  const Divider(
                    thickness: 0.4,
                    color: HcTheme.darkGrey2Color,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      IconText(
                        iconPath: 'duration_icon',
                        title: (timeInMins == 0)
                            ? "Calculating..."
                            : timeDetails(timeInMins),
                        style: mon12Blue,
                        iconColor: HcTheme.blueColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "|",
                        style: TextStyle(color: HcTheme.blueColor),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconText(
                        iconPath: 'distance_icon',
                        title: (distance == 0)
                            ? "Calculating..."
                            : '$distance kms',
                        style: mon12Blue,
                        iconColor: HcTheme.blueColor,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          await openGoogleMap(
                              lat: lat.isNotEmpty ? lat : '0.000',
                              lng: lng.isNotEmpty ? lng : '0.000',
                              address: userAdrs);
                        },
                        child: IconText(
                          iconPath: 'show_direction_icon',
                          title: 'Show direction',
                          style: mon12BlackSB.merge(
                            const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String timeDetails(int timeInMins) {
    if (timeInMins < 60) {
      return "$timeInMins mins";
    } else {
      int h = timeInMins ~/ 60;
      int min = timeInMins % 60;
      return "$h h $min mins";
    }
  }
}
