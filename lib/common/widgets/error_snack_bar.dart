import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';

void showErrorSnackBar(
    {required BuildContext context, required String errMsg}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errMsg),
      backgroundColor: HcTheme.redColor,
    ),
  );
}
