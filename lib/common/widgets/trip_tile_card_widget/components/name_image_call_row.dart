import 'package:drmohans_homecare_flutter/common/controller/punch_in_function.dart';
import 'package:drmohans_homecare_flutter/common/data/models/ride_item.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_trip_controller.dart';
import 'package:drmohans_homecare_flutter/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../theme.dart';
import '../../../../utils/helper_fuctions/helper.dart';
import '../../space.dart';

class NameImageCallRow extends StatelessWidget with HelperFunctions {
  const NameImageCallRow({super.key, required this.rideItem});
  final RideItem rideItem;

  @override
  Widget build(BuildContext context) {
    //--------------------------//
    bool? pickedStatus;
    if (rideItem.pickedStatus != null) {
      //Edit the pickup status according to the api response
      pickedStatus = rideItem.pickedStatus == "Item Picked";
    }
    final bool isDelivery = rideItem.hcType != "Collection";
    Size size = MediaQuery.of(context).size;
    //-------------------------//
    return Row(
      children: [
        CircleAvatar(
            backgroundImage:
                (rideItem.photoUrl != null && rideItem.photoUrl!.isNotEmpty)
                    ? NetworkImage(rideItem.photoUrl!)
                    : null,
            child: (rideItem.photoUrl == null || rideItem.photoUrl == '')
                ? Image.asset('assets/icons/png/profile_avatar.png')
                : null),
        Space.x(5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: size.width * 0.41),
                  child: Text(
                    "${rideItem.name}",
                    style: mon14BlackSB,
                  ),
                ),
                if (rideItem.orderId != null)
                  Row(
                    children: [
                      const SizedBox(
                        height: 15,
                        child: VerticalDivider(thickness: 1),
                      ),
                      Text(
                        "#RIDE${rideItem.orderId}",
                        style: mon14darkGrey1,
                      )
                    ],
                  )
              ],
            ),
            Space.y(4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isDelivery
                          ? const Color.fromARGB(255, 230, 250, 231)
                          : const Color.fromARGB(255, 233, 241, 249)),
                  child: Row(
                    children: [
                      isDelivery
                          ? SvgPicture.asset(
                              'assets/icons/svg/delivery_card_tag.svg')
                          : SvgPicture.asset(
                              'assets/icons/svg/collection_card_tag.svg'),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        isDelivery ? 'DELIVERY' : "COLLECTION",
                        style: isDelivery ? mon10Green600 : mon10Blue600,
                      )
                    ],
                  ),
                ),
                Space.x(5),
                if (isDelivery && (pickedStatus != null)
                    // &&rideItem.pickedStatus != ""
                    )
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      pickedStatus
                          ? SvgPicture.asset(
                              'assets/icons/svg/green_tick.svg',
                              height: 10,
                              colorFilter: const ColorFilter.mode(
                                  HcTheme.greenColor, BlendMode.srcIn),
                            )
                          : SvgPicture.asset(
                              'assets/icons/svg/unscheduled.svg',
                              height: 12,
                              colorFilter: const ColorFilter.mode(
                                  HcTheme.redColor, BlendMode.srcIn),
                            ),
                      Space.x(2),
                      Text(
                        pickedStatus ? 'Item picked' : 'Pickup pending',
                        style: pickedStatus ? mon10Green : mon10Red,
                      )
                    ],
                  )
              ],
            )
          ],
        ),
        const Spacer(),
        Consumer(builder: (context, ref, child) {
          final isPunched = ref.watch(isPunchedIn);
          final tripStart = ref.watch(tripStartProvider);

          return InkWell(
            onTap: () async {
              if (isPunched == true) {
                if (tripStart == true) {
                  final phone = rideItem.mobile;
                  await dialPhoneNumber(phone);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Start trip to continue'),
                      backgroundColor: HcTheme.greenColor,
                    ),
                  );
                }
              } else {
                punchIn(context);
              }
            },
            child: const Icon(
              Icons.phone,
              color: HcTheme.greenColor,
            ),
          );
        })
      ],
    );
  }
}
