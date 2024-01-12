import 'package:drmohans_homecare_flutter/common/controller/time_controller.dart';
import 'package:drmohans_homecare_flutter/common/widgets/bottom_sheet.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/models/get_order_details_model.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/icon_text.dart';

class ProductData extends StatelessWidget {
  final String deliveryDate, pickedStatus, orderId;
  // final String productName;
  final DateTime deliveryTime;
  // final int quantity;
  final bool isHistory;
  final List<ListElement> productList;
  const ProductData(
      {super.key,
      required this.deliveryDate,
      required this.deliveryTime,
      // required this.productName,
      this.isHistory = false,
      // required this.quantity,
      required this.pickedStatus,
      required this.orderId,
      required this.productList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Visibility(
            visible: !isHistory,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Date",
                      style: mon16BlackSB,
                    ),
                    const SizedBox(height: 8),
                    IconText(
                        iconPath: 'calendar_icon',
                        iconColor: HcTheme.blueColor,
                        iconHeight: 14,
                        title: deliveryDate,
                        style: mon14Black)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery time",
                      style: mon16BlackSB,
                    ),
                    const SizedBox(height: 8),
                    Consumer(
                      builder: (context, ref, child) {
                        final finalController =
                            ref.watch(finalCollectionTimeProvider);
                        final changedController =
                            ref.watch(changedCollectionTimeProvider);

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconText(
                                iconPath: 'duration_icon',
                                iconColor: HcTheme.blueColor,
                                iconHeight: 15,
                                title: changedController.isEmpty
                                    ? DateFormat('hh:mm a').format(deliveryTime)
                                    : changedController,
                                style: mon14Black),
                            InkWell(
                              onTap: () {
                                final DateTime collTime;

                                if (finalController == null) {
                                  collTime = deliveryTime;
                                } else {
                                  collTime = finalController;
                                }

                                ref.read(currentTimeProvider.notifier).state =
                                    TimeOfDay.fromDateTime(collTime);

                                ref
                                    .read(
                                        currentCollectionTimeProvider.notifier)
                                    .state = collTime;

                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        topLeft: Radius.circular(12),
                                      ),
                                    ),
                                    builder: (BuildContext context) {
                                      return CollectionTimeBottomsheet(
                                        orderId: orderId,
                                      );
                                    });
                              },
                              child: Text(
                                'Edit',
                                style: mon14Blue.merge(const TextStyle(
                                    decoration: TextDecoration.underline)),
                              ),
                            )
                          ],
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          //---------------------------- Product image, name, quantity-------------------------------
          // productImageDetails()
          // Expanded(
          //   child: ListView.builder(
          //       itemCount: productList.length,
          //       itemBuilder: (context, index) {
          //         return productsTile(productList[index].serviceId,
          //             productList[index].serviceName);
          //       }),

          // )

          ...productList.map((e) => ProductTile(
                id: e.serviceId,
                productName: e.serviceName,
              )),
        ],
      ),
    );
  }

//--------------------------  Old ---------------------------------
  // Widget productImageDetails() {
  //   return Row(
  //     children: [
  //       SvgPicture.asset('assets/images/svg/product_img.svg'),
  //       const SizedBox(
  //         width: 10,
  //       ),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               productName,
  //               style: mon14BlackSB,
  //             ),
  //             const SizedBox(height: 6),
  //             const Text(
  //               'Quantity',
  //               style: mon14lightGrey3,
  //             ),
  //             const SizedBox(height: 6),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   '$quantity',
  //                   style: mon14Black,
  //                 ),
  //                 if (pickedStatus == '1')
  //                   const IconText(
  //                     iconPath: 'green_tick',
  //                     style: mon14Green,
  //                     title: 'Item Picked',
  //                   )
  //               ],
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }
}

class ProductTile extends StatelessWidget {
  final String id, productName;
  const ProductTile({super.key, required this.id, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3.0),
            child: Icon(
              Icons.production_quantity_limits,
              size: 17,
              color: HcTheme.greenColor,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID :  $id',
                  style: mon14Black,
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  'Name :  $productName',
                  style: mon14Black,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
