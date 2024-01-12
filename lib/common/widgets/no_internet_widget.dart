import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 100,
            color: HcTheme.lightGrey1Color,
          ),
          Text(
            "Internet connection lost!!",
            style: mon16BlackSB,
            textAlign: TextAlign.center,
          ),
          Text('Check your internet connection and try again')
        ],
      ),
    );
  }
}
