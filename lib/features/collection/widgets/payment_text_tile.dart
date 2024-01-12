import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';

class PaymentReceivedTextTile extends StatelessWidget {
  final String? title;
  final String data;
  const PaymentReceivedTextTile(
      {Key? key, required this.title, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: Text(
                title ?? "",
                style: mon14BlackSB,
              )),
          const Text(":"),
          Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width / 2.5,
              child: Text(
                data,
                style: mon14Black,
              )),
        ],
      ),
    );
  }
}
