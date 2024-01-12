import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/grey_container.dart';

class UserBannerSmall extends StatelessWidget {
  const UserBannerSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GreyCard(
      height: size.height * 0.15,
      width: size.width,
      padding: const EdgeInsets.only(top: 12),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                    'https://www.cameraegg.org/wp-content/uploads/2013/02/Nikon-D7100-Sample-Image-1.jpg',
                    height: 52,
                    width: 52,
                    fit: BoxFit.cover)),
            SizedBox(
              width: size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pradeep Kumar",
                    style: mon16BlackSB,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  RichText(
                      text: const TextSpan(
                          text: "MRN: ",
                          style: mon14lightGrey3,
                          children: [
                        TextSpan(text: "1234567890"),
                        TextSpan(text: " | "),
                        TextSpan(text: " 24,"),
                        TextSpan(text: " Male"),
                      ])),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/svg/location.svg'),
                      const SizedBox(
                        width: 8,
                      ),
                      const SizedBox(
                          width: 190,
                          child: Text(
                            "Room no 301, SG apartment, sec 11, Bengaluru,76543",
                            style: mon12BlackSB,
                            maxLines: 3,
                          ))
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.call,
                  color: HcTheme.greenColor,
                  size: 32,
                ))
          ],
        ),
      ),
    );
  }
}
