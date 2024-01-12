import 'package:drmohans_homecare_flutter/features/dashboard/data/services/dashboard_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/get_order_details_model.dart';

final orderDetailsController = StateNotifierProvider.family<
    OrderDetailsController, OrderDetailsStates, List<String>>((ref, data) {
  final service = ref.watch(dashboardServiceProvider);
  return OrderDetailsController(service, data);
});

class OrderDetailsController extends StateNotifier<OrderDetailsStates> {
  final DashboardServices service;
  final List<String> data;
  OrderDetailsController(this.service, this.data)
      : super(OrderDetailsInitial()) {
    getOrderDetails();
  }

  Future<void> getOrderDetails() async {
    try {
      state = OrderDetailsLoading();
      final res = await service.getOrderDetails(data[0], data[1]);
      state = OrderDetailsSuccess(res);
    } catch (e) {
      debugPrint("------eee--------------$e");
      state = OrderDetailsError();
    }
  }
}

abstract class OrderDetailsStates {}

class OrderDetailsLoading extends OrderDetailsStates {}

class OrderDetailsInitial extends OrderDetailsStates {}

class OrderDetailsSuccess extends OrderDetailsStates {
  final GetOrderDetails data;
  OrderDetailsSuccess(this.data);
}

class OrderDetailsError extends OrderDetailsStates {}
