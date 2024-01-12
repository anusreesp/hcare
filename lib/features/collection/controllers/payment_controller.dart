import 'dart:developer';

import 'package:drmohans_homecare_flutter/features/collection/data/services/payment_services.dart';
import 'package:drmohans_homecare_flutter/services/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentController =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  final paymentServices = ref.watch(paymentServiceProvider);
  final values = ref.watch(flutterStorageProvider);
  return PaymentNotifier(paymentServices: paymentServices, allValues: values);
});

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentServices paymentServices;
  final Map<String, String> allValues;
  PaymentNotifier({required this.paymentServices, required this.allValues})
      : super(PaymentIntial());
  Future<dynamic> payment(
      {required String orderId,
      required String payMode,
      required String desc}) async {
    final userId = allValues[StorageKeys.uid];
    final empId = allValues[StorageKeys.empId];
    final data = {
      "UserID": userId,
      "EmpID": empId,
      "OrderID": orderId,
      "PayMode": payMode,
      "PayDesc": desc,
      "PaySts": "paid"
    };
    log(data.toString());
    try {
      final result = await paymentServices.paymet(data);
      return result;
    } catch (e) {
      state = PaymentError(e.toString());
    }
  }

  Future<dynamic> sendRazorpayLink(
      {required String orderId, required String mobile}) async {
    final userId = allValues[StorageKeys.uid];
    final empId = allValues[StorageKeys.empId];
    final data = {
      "UserID": userId,
      "EmpID": empId,
      "OrderID": orderId,
      "RazMob": mobile
    };
    log(data.toString());
    try {
      final result = await paymentServices.sendRazorpayLink(data);
      return result;
    } catch (e) {
      state = PaymentError(e.toString());
    }
  }
}

abstract class PaymentState {}

class PaymentIntial extends PaymentState {}

class PaymentError extends PaymentState {
  final String errMsg;

  PaymentError(this.errMsg);
}
