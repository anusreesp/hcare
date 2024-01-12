import 'package:drmohans_homecare_flutter/features/history/controller/handover_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/grey_container.dart';
import '../../../../common/widgets/main_appbar.dart';
import '../../../../common/widgets/main_background.dart';
import '../../../collection/widgets/payment_text_tile.dart';

class HandoverDetails extends ConsumerWidget {
  const HandoverDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final handOverController = ref.watch(handOverDetailsProvider);

    return Scaffold(
      appBar: MainAppbar(
          onBackButtonPressed: () {
            Navigator.pop(context);
          },
          title: "Handover Details"),
      body: MainBackgroundComponent(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          stops: const [0.155, 0.15],
          child: Column(
            children: [
              if (handOverController is HandOverLoaded)
                Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    const Row(
                      children: [
                        Text("Your Trip ", style: mon16White600),
                        Text(
                          "handover details",
                          style: mon16lightGreenSB,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/svg/calendar_icon.svg',
                          colorFilter: const ColorFilter.mode(
                              HcTheme.whiteColor, BlendMode.srcIn),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          DateFormat('dd MMM yyyy').format(DateTime.now()),
                          style: mon12White,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GreyCard(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      width: size.width,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total Patients",
                                    style: mon14BlackSB,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        handOverController
                                            .response.patientCount,
                                        style: mon36Green,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "patients",
                                          style: mon14BlackSB,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "No of Samples collected",
                                    style: mon14BlackSB,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        handOverController
                                            .response.samplesCount,
                                        style: mon36Green,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "samples",
                                          style: mon14BlackSB,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Stack(
                          //     alignment: Alignment.centerRight,
                          //     children: [
                          //       for (var i = 0; i < 5; i++)
                          //         Padding(
                          //           padding: EdgeInsets.only(right: i * 16),
                          //           child: ClipRRect(
                          //               borderRadius: BorderRadius.circular(60),
                          //               child: Image.network(
                          //                 'https://www.newarab.com/sites/default/files/styles/large_16_9/public/2022-10/Andrew_Tate_on_%27Anything_Goes_With_James_English%27_in_2021.jpg?h=25926a0d&itok=etBlghfn',
                          //                 width: 32,
                          //                 height: 32,
                          //                 fit: BoxFit.cover,
                          //               )),
                          //         ),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      children: [
                        Text("Payment Details", style: mon16BlackSB),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),

                    if (handOverController.response.cash != '')
                      PaymentReceivedTextTile(
                          title: "Cash",
                          data: "₹ ${handOverController.response.cash}"),

                    if (handOverController.response.card != '')
                      PaymentReceivedTextTile(
                          title: 'Card',
                          data: "₹ ${handOverController.response.card}"),
                    if (handOverController.response.ewallet != '')
                      PaymentReceivedTextTile(
                          title: 'Ewallet',
                          data: '₹ ${handOverController.response.ewallet}'),
                    if (handOverController.response.total != '')
                      PaymentReceivedTextTile(
                          title: 'Total',
                          data: '₹ ${handOverController.response.total}'),

                    // const PaymentReceivedTextTile(title: "Cash", data: "₹ 400"),
                    // const PaymentReceivedTextTile(title: "Cash", data: "₹ 400"),
                    // const PaymentReceivedTextTile(title: "Cash", data: "₹ 400"),

                    PaymentReceivedTextTile(
                        title: "Description",
                        data: handOverController.response.desc != ''
                            ? handOverController.response.desc
                            : "NA"),
                  ],
                ),
              if (handOverController is HandOverLoading)
                const SizedBox(
                  // height: size.height,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (handOverController is HandOverError)
                SizedBox(
                  // height: size.height,
                  width: size.width,
                  child: Center(
                    child: Text(handOverController.error),
                  ),
                )
            ],
          )),
    );
  }
}
