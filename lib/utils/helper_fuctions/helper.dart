import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

mixin HelperFunctions {
  Future<void> dialPhoneNumber(String? phone) async {
    if (phone != null) {
      final number = phone.split(' /');
      log('$number');
      final url = Uri(scheme: 'tel', path: '+91-${number[0]}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not open the dialler.';
      }
    }
  }

  Map<String, String> getFromAndToDate(String filterSelected) {
    DateTime today = DateTime.now();
    final dateFormat = DateFormat('MM/dd/yyyy');
    String fromDate = '';
    String toDate = '';
    switch (filterSelected) {
      case "Today":
        fromDate = dateFormat.format(today);
        toDate = dateFormat.format(today);
        break;
      case "Tomorrow":
        fromDate = dateFormat.format(today.add(const Duration(days: 1)));
        toDate = dateFormat.format(today.add(const Duration(days: 1)));
        break;
      case "Yesterday":
        fromDate = dateFormat.format(today.subtract(const Duration(days: 1)));
        toDate = dateFormat.format(today.subtract(const Duration(days: 1)));
        break;
      case "Last 7 days":
        fromDate = dateFormat.format(today.subtract(const Duration(days: 7)));
        toDate = dateFormat.format(today);
        break;
      case "Last 30 days":
        fromDate = dateFormat.format(today.subtract(const Duration(days: 30)));
        toDate = dateFormat.format(today);
        break;
      default:
        fromDate = dateFormat.format(today);
        toDate = dateFormat.format(today);
        break;
    }

    return {"FromDate": fromDate, "ToDate": toDate};
  }

  Future<void> openGoogleMap(
      {required String lat,
      required String lng,
      required String address}) async {
    // String url;
    // if (lat == "" && lng == "") {
    //   url = "https://www.google.com/maps/search/?api=1&query=0.0, 0.0";
    // } else {
    //   url = "https://www.google.com/maps/search/?api=1&query=$lat, $lng";
    // }
    // Uri uri = Uri.parse(url);
    // if (!await launchUrl(uri)) {
    //   throw Exception('Could not launch $uri');
    // }

    String url;

    final cleanedAddress = address.replaceAll(" ", "");

    final finalAdrs = cleanedAddress.replaceAll(RegExp(r',{1,}'), '+');

    if (address == '') {
      url = 'https://maps.google.com/?q=';
    } else {
      url = 'https://maps.google.com/?q=$finalAdrs';
    }

    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
