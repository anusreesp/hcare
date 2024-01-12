import 'package:drmohans_homecare_flutter/common/data/models/ride_item.dart';
import 'package:drmohans_homecare_flutter/common/widgets/icon_text.dart';
import 'package:drmohans_homecare_flutter/common/widgets/pricing.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/view_order_details_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/models/get_order_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/main_appbar.dart';
import '../../../../common/widgets/main_background.dart';
import '../../../../common/widgets/space.dart';
import '../../../../theme.dart';
import '../../../delivery/widgets/product_data.dart';
import '../../../collection/widgets/user_card_service_details.dart';

class ProductDetailsHistory extends ConsumerWidget {
  final RideItem data;
  ProductDetailsHistory({Key? key, required this.data}) : super(key: key);

  List<String> orderData = [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    orderData.add(data.orderId ?? "");
    orderData.add(data.hcType ?? "");
    final rideDetails = ref.watch(orderDetailsController(orderData));

    return Scaffold(
      appBar: MainAppbar(
          title: "History",
          onBackButtonPressed: () {
            Navigator.pop(context);
          }),
      body: SingleChildScrollView(
        child: MainBackgroundComponent(
            stops: const [0.17, 0.17],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Delivery ID',
                            style: mon16WhiteSBold,
                          ),
                          Text(
                            ' #${data.orderId ?? ''}',
                            style: mon16lightGreenSB,
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      UserCardForServiceDetails(
                        isHistory: true,
                        data: data,
                      ),
                      const SizedBox(height: 16),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Completed Delivery Details",
                            style: mon16BlackSB,
                          )),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/svg/calendar_icon.svg',
                              colorFilter: const ColorFilter.mode(
                                  HcTheme.blackColor, BlendMode.srcIn)),
                          // const Icon(
                          //   Icons.calendar_today_outlined,
                          //   size: 12,
                          // ),
                          Space.x(4),
                          Text(
                            DateFormat('dd MMM yyyy')
                                .format(DateTime.parse(data.date ?? '')),
                            style: mon12Black,
                          ),
                          Container(
                            height: 12,
                            width: 1,
                            color: HcTheme.lightGrey3Color,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          SvgPicture.asset('assets/icons/svg/clock_icon.svg',
                              colorFilter: const ColorFilter.mode(
                                  HcTheme.blackColor, BlendMode.srcIn)),
                          // const Icon(
                          //   Icons.lock_clock,
                          //   size: 12,
                          // ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            DateFormat('hh:mm a').format(
                                DateTime.parse(data.collDeliverTime ?? '')),
                            style: mon12Black,
                          )
                        ],
                      ),
                      Space.y(8),
                      // ProductData(
                      //   deliveryDate: '28 Feb 2023',
                      //   deliveryTime: DateTime.now(),
                      //   // productName: 'Diabetic Footwear Slipper -Brown 6',
                      //   // quantity: 1,
                      //   productList: [],
                      //   isHistory: true,
                      //   pickedStatus: '0',
                      //   orderId: '9989',
                      // ),

                      if (rideDetails is OrderDetailsSuccess &&
                          data.hcType == 'Collection')
                        SizedBox(
                          height: rideDetails.data.list.length * 32,
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: rideDetails.data.list.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: IconText(
                                      iconPath: 'tick',
                                      title: rideDetails
                                          .data.list[index].serviceName,
                                      style: mon14Black),
                                );
                              }),
                        ),

                      if (rideDetails is OrderDetailsSuccess &&
                          data.hcType == 'Delivery')
                        ...rideDetails.data.list.map((e) => ProductTile(
                              id: e.serviceId,
                              productName: e.serviceName,
                            )),
                    ],
                  ),
                ),
                const Divider(
                  color: HcTheme.lightGrey1Color,
                  thickness: 1.1,
                ),
                Space.y(8),
                if (rideDetails is OrderDetailsSuccess)
                  Pricing(
                      price: '₹${rideDetails.data.grossAmount}',
                      discount: '- ₹${rideDetails.data.discount}',
                      totalPay: '₹${rideDetails.data.netAmount}')
                // Column(
                //   children: [
                //     if (rideDetails is OrderDetailsSuccess)
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 14),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             const Text(
                //               'Subtotal',
                //             ),
                //             Text(
                //               '₹${rideDetails.data.grossAmount}',
                //               style: mon16BlackSB,
                //             )
                //           ],
                //         ),
                //       ),
                //   ],
                // ),
                // Space.y(10),
                // if (rideDetails is OrderDetailsSuccess)
                //   Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 14),
                //     child: Row(
                //       children: [
                //         const Text('Discount'),
                //         Space.x(5),
                //         const Icon(
                //           Icons.percent,
                //           color: HcTheme.greenColor,
                //           size: 16,
                //         ),
                //         const Spacer(),
                //         Text(
                //           '-₹${rideDetails.data.discount}',
                //           style: mon16GreenSB,
                //         )
                //       ],
                //     ),
                //   ),
                // Space.y(10),
                // const Divider(
                //   thickness: 1,
                //   color: HcTheme.lightGrey1Color,
                // ),
                // Space.y(10),
                // if (rideDetails is OrderDetailsSuccess)
                //   Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 14),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         const Text(
                //           'Total Payable',
                //           style: mon16BlackSB,
                //         ),
                //         Text(
                //           '₹${rideDetails.data.netAmount}',
                //           style: mon16GreenSB,
                //         )
                //       ],
                //     ),
                //   ),
                // Space.y(10),
                // const Divider(
                //   thickness: 1,
                //   color: HcTheme.lightGrey1Color,
                // ),
              ],
            )),
      ),
    );
  }
}
