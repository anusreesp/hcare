import 'package:drmohans_homecare_flutter/features/profile/controller/notification_controller.dart';
import 'package:drmohans_homecare_flutter/features/profile/screens/notification_card.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/icon_text.dart';

class NotificationScreen extends ConsumerWidget {
  static const route = '/notification-screen';
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final notificationData = ref.watch(notificationProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          leading: IconButton(icon: const Icon(Icons.arrow_back,color: Colors.white),onPressed: (){
            Navigator.pop(context);
          }),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              children: [
                if (notificationData is NotificationLoaded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),

                      //--------------------------------- Today -------------------------------------
                      if(notificationData.today.isNotEmpty)
                        const Text("Today", style: mon16BlackSB),
                      const SizedBox(
                        height: 4,
                      ),
                        if(notificationData.today.isNotEmpty)
                          ...notificationData.today.map((element,) {
                            return  NotificationCard(
                                iconPath: 'pills',
                                title: 'Medicine Pickup',
                                duration: element.date);
                          }),
                      if(notificationData.today.isNotEmpty)
                        const Text("Yesterday", style: mon16BlackSB),
                      const SizedBox(
                        height: 4,
                      ),
                      if(notificationData.yesterday.isNotEmpty)
                        ...notificationData.yesterday.map((element,) {
                          return  NotificationCard(
                              iconPath: 'pills',
                              title: 'Medicine Pickup',
                              duration: element.date);
                        }),
                      if(notificationData.earlier.isNotEmpty)
                        const Text("Earlier", style: mon16BlackSB),
                      const SizedBox(
                        height: 4,
                      ),
                      if(notificationData.earlier.isNotEmpty)
                        ...notificationData.earlier.map((element,) {
                          return  NotificationCard(
                              iconPath: 'pills',
                              title: element.notifyTitle,
                              duration: element.date,
                                child: rescheduled(
                                   element.notifyContent,element.date ),
                              );
                        })

                      // const NotificationCard(
                      //     iconPath: 'warning',
                      //     title: 'Trip Cancelled',
                      //     duration: '1 hr ago'),
                      // NotificationCard(
                      //   iconPath: 'clock',
                      //   title: 'Trip Rescheduled',
                      //   duration: '2 hrs ago',
                      //   child: rescheduled(
                      //       'Jagadish Kumar', 'DELIVERY', '28 Feb 2023', '10:00 AM'),
                      // ),
                      //
                      // const SizedBox(
                      //   height: 24,
                      // ),
                      //
                      // //---------------------------------- This week ------------------------------------
                      // const Text("This week", style: mon16BlackSB),
                      // const SizedBox(
                      //   height: 4,
                      // ),
                      //
                      // const NotificationCard(
                      //     iconPath: 'pills',
                      //     title: 'Medicine Pickup',
                      //     duration: 'yesterday'),
                      // const NotificationCard(
                      //     iconPath: 'warning',
                      //     title: 'Trip Cancelled',
                      //     duration: '3 days ago'),
                      // NotificationCard(
                      //   iconPath: 'clock',
                      //   title: 'Trip Rescheduled',
                      //   duration: '4 days ago',
                      //   child: rescheduled(
                      //       'Jagadish Kumar', 'DELIVERY', '28 Feb 2023', '10:00 AM'),
                      // )
                    ],
                  ),
                if (notificationData is NotificationLoading)
                  SizedBox(
                    height: size.height,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            ),
          ),
        ));
  }

  Widget rescheduled(String userName, DateTime date,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            style: mon12BlackMedium,
          ),
          const SizedBox(
            height: 12,
          ),
          // Container(
          //   width: 70,
          //   height: 15,
          //   color: type != "DELIVERY"
          //       ? HcTheme.lightBlue2Color
          //       : HcTheme.lightGreen1Color,
          //   child: Row(
          //     children: [
          //       SvgPicture.asset(
          //           'assets/icons/svg/${type != "DELIVERY" ? "collection_card_tag" : "delivery_card_tag"}.svg'),
          //       const SizedBox(
          //         width: 4,
          //       ),
          //       Text(
          //         type,
          //         style: type != "DELIVERY" ? mon10Blue600 : mon10Green600,
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              IconText(
                  iconPath: 'calendar_icon',
                  title: DateFormat('dd MMM yyyy').format(date),
                  style: mon12lightGrey3),
              Text(
                "  |  ",
                style: mon12lightGrey3.merge(
                    TextStyle(color: HcTheme.lightGrey3Color.withOpacity(0.3))),
              ),
              IconText(
                  iconPath: 'calendar_icon',
                  title: DateFormat('hh:mm a').format(date),
                  style: mon12lightGrey3)
            ],
          )
        ],
      ),
    );
  }
}
