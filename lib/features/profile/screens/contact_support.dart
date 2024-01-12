import 'package:drmohans_homecare_flutter/features/profile/controller/support_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/grey_container.dart';
import '../../../common/widgets/icon_text.dart';
import '../../../common/widgets/main_background.dart';

class ContactSupportScreen extends ConsumerWidget {
  static const route = '/contact-support';
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final details = ref.watch(supportDetailsProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Contact support'),
        ),
        body: MainBackgroundComponent(
            stops: const [0.2, 0.2],
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    if (details is SupportLoaded)
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'For Support and Assistance',
                                    style: mon18white,
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "We'd love to hear from you. Our team will revert",
                                    style: mon12White,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                            //--------------------------------Contact Number--------------------------------
                            greyCardData(
                              'Phone', 'contact_support/phone',
                              // '+91-9876540765', 'Mon-Fri from 8am to 5pm'
                              details.data.mobile, details.data.mobileDesc,
                            ),

                            const SizedBox(
                              height: 8,
                            ),
                            greyCardData(
                                'Mail',
                                'contact_support/email',
                                // 'info@dr.mohans.com',
                                // 'Our team is here to help'
                                details.data.email,
                                details.data.emailDesc)
                          ]),
                    if (details is SupportLoading)
                      SizedBox(
                        height: size.height,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                  ],
                ))));
  }

  Widget greyCardData(
    String title,
    String iconPath,
    String iconText,
    String content,
  ) {
    return GreyCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: mon16BlackSB,
            ),
            const SizedBox(
              height: 6,
            ),
            IconText(
                iconPath: iconPath,
                iconHeight: 13,
                iconWidth: 13,
                title: iconText,
                style: mon14Black),
            const SizedBox(
              height: 8,
            ),
            Text(
              content,
              style: mon12lightGrey3,
            ),
          ],
        ),
      ),
    );
  }
}
