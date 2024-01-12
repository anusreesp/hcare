import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Pricing extends StatelessWidget {
  final String price, discount, totalPay;
  const Pricing(
      {super.key,
      required this.price,
      required this.discount,
      required this.totalPay});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: mon14BlackSB,
                  ),
                  Text(
                    price,
                    style: mon16BlackSB,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Discount',
                        style: mon14BlackSB,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      SvgPicture.asset('assets/icons/svg/discount_icon.svg')
                    ],
                  ),
                  Text(
                    discount,
                    style: mon16darkGreenSB,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 0.4,
          color: HcTheme.darkGrey2Color,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payable',
                style: mon16BlackSB,
              ),
              Text(
                discount,
                style: mon18darkGreenSB,
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 0.4,
          color: HcTheme.darkGrey2Color,
        ),
      ],
    );
  }
}
