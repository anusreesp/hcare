import 'package:drmohans_homecare_flutter/common/controller/punch_in_function.dart';
import 'package:drmohans_homecare_flutter/features/profile/controller/profile_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/grey_container.dart';
import '../../../common/widgets/space.dart';
import '../../../utils/helper_fuctions/helper.dart';

class CustomerDetailsCard extends StatelessWidget with HelperFunctions {
  const CustomerDetailsCard({
    super.key,
    required this.address,
    required this.age,
    required this.gender,
    required this.mobile,
    required this.mrn,
    required this.name,
    required this.photoUrl,
    this.isHistory = false,
  });

  final dynamic photoUrl;
  final String name;
  final String address;
  final String mrn;
  final String age;
  final String gender;
  final String mobile;
  final bool isHistory;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GreyCard(
      width: size.width,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 22,
              backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
                  ? NetworkImage(photoUrl!)
                  : null,
              child: (photoUrl == null || photoUrl == '')
                  ? Image.asset(
                      'assets/icons/png/profile_avatar.png',
                    )
                  : null,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: mon14BlackSB,
                ),
                Space.y(5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      mrn,
                      style: mon14darkGrey1,
                    ),
                    const SizedBox(
                      height: 15,
                      child: VerticalDivider(
                        color: HcTheme.darkGrey1Color,
                      ),
                    ),
                    Text(
                      '$age,$gender',
                      style: mon14darkGrey1,
                    )
                  ],
                ),
                Space.y(5),
                Visibility(
                  visible: isHistory,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            size: 16,
                            Icons.call,
                            color: HcTheme.greenColor,
                          ),
                          Space.x(5),
                          Consumer(builder: (BuildContext context,
                              WidgetRef ref, Widget? child) {
                            final isPunched = ref.watch(isPunchedIn);

                            return InkWell(
                              onTap: () async {
                                if (isPunched) {
                                  await dialPhoneNumber(mobile);
                                } else {
                                  punchIn(context);
                                }
                              },
                              child: Text(
                                '+91-${mobile.split(' /')[0]}',
                                style: mon12BlackMedium,
                              ),
                            );
                          })
                        ],
                      ),
                      Space.y(5),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset('assets/icons/svg/location.svg'),
                    Space.x(5),
                    Expanded(
                      child: Text(
                        address,
                        style: mon12BlackMedium,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Visibility(
            visible: !isHistory,
            child: IconButton(
                onPressed: () async {
                  await dialPhoneNumber(mobile);
                },
                icon: const Icon(
                  Icons.call,
                  color: HcTheme.greenColor,
                )),
          )
        ],
      ),
    );
  }
}
