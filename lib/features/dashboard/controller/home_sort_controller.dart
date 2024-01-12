import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/data/models/ride_item.dart';

final homeSortListProvider =
    StateNotifierProvider<HomeSortListController, List<RideItem>>((ref) {
  final dashboardController = ref.watch(dashboardProvider);
  if (dashboardController is DashboardLoaded) {
    return HomeSortListController(dashboardController.dashboardData.lst);
  } else {
    return HomeSortListController([]);
  }
});

class HomeSortListController extends StateNotifier<List<RideItem>> {
  final List<RideItem> rideItems;

  HomeSortListController(this.rideItems) : super(rideItems);

  sortRideItem(String sortType) {
    switch (sortType) {
      case 'Time ascending':
        ascending();
        break;

      case 'Completed':
        rideCompleted();
        break;
      case 'Pending':
        ridePending();
        break;
    }
  }

  ascending() {
    debugPrint("--- sort----------------ascending");
    rideItems.sort((a, b) => a.date!.compareTo(b.date!));
    state = [...rideItems];
  }

  rideCompleted() {
    debugPrint("--- sort----------------Completed");
    // rideItems.sort((a, b) => a.hcStatus == 'Completed' ? -1 : 1);
    rideItems.sort((a, b) => a.hcStatus == 'Completed' ? -1 : 1);

    state = [...rideItems];
  }

  ridePending() {
    debugPrint("--- sort----------------Pending");
    rideItems.sort((a, b) => a.hcStatus == 'Pending' ? -1 : 1);

    state = [...rideItems];
  }

  rideStatus(String status) {
    debugPrint("--- sort----------------$status");
    rideItems.sort((a, b) => a.hcStatus == status ? -1 : 1);
    state = [...rideItems];
  }
}
