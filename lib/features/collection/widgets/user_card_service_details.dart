import 'package:drmohans_homecare_flutter/common/data/models/ride_item.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/models/get_order_details_model.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/grey_container.dart';
import '../../../common/widgets/space.dart';

class UserCardForServiceDetails extends StatelessWidget {
  final bool isHistory;
  // final GetOrderDetails data;
  final RideItem data;
  const UserCardForServiceDetails(
      {Key? key, required this.data, this.isHistory = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GreyCard(
      // height: size.height * 0.15,
      width: size.width,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 22,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // 'Pradeep Kumar',
                  data.name ?? '',
                  style: mon14BlackSB,
                ),
                Space.y(5),
                Column(
                  children: [
                    Row(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'MRN:${data.mrn}',
                          style: mon12lightGrey3,
                        ),
                        const SizedBox(
                          height: 15,
                          child: VerticalDivider(
                            color: HcTheme.lightGrey1Color,
                          ),
                        ),
                        // Text(
                        //   '${data.age},${data.gender}',
                        //   style: mon12lightGrey3,
                        // )
                      ],
                    ),
                    Space.y(8),
                    Visibility(
                      visible: isHistory,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SvgPicture.asset(
                              //   'assets/icons/svg/call.svg',
                              //   width: 14,

                              // ),
                              Icon(
                                Icons.phone,
                                color: HcTheme.greenColor,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child:
                                    Text('${data.mobile}', style: mon14BlackSB),
                              )
                            ],
                          ),
                          Space.y(8),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child:
                              SvgPicture.asset('assets/icons/svg/location.svg'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(data.address ?? '', style: mon12BlackSB),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: !isHistory,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.call,
                  color: HcTheme.greenColor,
                )),
          ),
        ],
      ),
    );
  }
}
