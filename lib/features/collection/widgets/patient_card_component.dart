import 'package:drmohans_homecare_flutter/common/widgets/space.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/widgets/grey_container.dart';

class PatientCardComponent extends StatelessWidget {
  final bool isHistory;

  final String gender;
  final String name;
  final String age;
  final String mrn;
  const PatientCardComponent({Key? key, this.isHistory = false, required this.gender, required this.name, required this.age, required this.mrn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GreyCard(
      // height: size.height * 0.15,
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Space.x(12),
            ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SvgPicture.asset(
                  'assets/icons/svg/profile_avatar.svg',
                  width: 60,
                  height: size.height/16,
                )),
            Space.x(8),
            SizedBox(
              width: size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    name,
                    style: mon14BlackSB,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  RichText(
                      text:  TextSpan(
                          text: "MRN: ",
                          style: mon12BlackSB,
                          children: [
                        TextSpan(text: mrn),
                      ])),
                  const SizedBox(
                    height: 4,
                  ),
                  RichText(
                      text:  TextSpan(
                          text: "$age, ",
                          style: mon12BlackSB,
                          children: [
                        TextSpan(text: gender),
                      ])),
                  Visibility(
                      visible: isHistory,
                      child: const Column(
                        children: [],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
