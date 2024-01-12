import 'dart:developer';

import 'package:drmohans_homecare_flutter/common/controller/internet_connection_controller.dart';
import 'package:drmohans_homecare_flutter/common/widgets/no_internet_widget.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/dashboard.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/ride_filter_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/rides_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/tab_controller.dart';
import 'package:drmohans_homecare_flutter/utils/helper_fuctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/main_appbar.dart';
import '../../../../theme.dart';
import '../../controllers/collection_or_delivery_controller.dart';
import '../screen_components/ride_data.dart';

class MyRidesScreen extends ConsumerStatefulWidget {
  const MyRidesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends ConsumerState<MyRidesScreen>
    with HelperFunctions {
  final ScrollController sliverScrollController = ScrollController();
  final ScrollController backgroundScrollController = ScrollController();

  @override
  void initState() {
    sliverScrollController.addListener(_scrollListener);
    super.initState();
  }

  void getData() {
    int hcStatus;
    final filterSelected = ref.watch(rideFilterProvider);
    final status = ref.watch(myRidesScreenTabController);
    final dates = getFromAndToDate(filterSelected);
    final type = ref.watch(collectionOrDeliveryController);
    log(type);
    if (status == 0) {
      hcStatus = 0;
    } else if (status == 1) {
      hcStatus = 2;
    } else if (status == 2) {
      hcStatus = 3;
    } else {
      hcStatus = 1;
    }
    ref.read(ridesProvider.notifier).getRides(
          fromDate: dates["FromDate"]!,
          toDate: dates["ToDate"]!,
          hcStatus: hcStatus,
          type: type,
        );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final internet = ref.watch(internetProvider);
    getData();
    return Scaffold(
      appBar: MainAppbar(
        onBackButtonPressed: () {
          tabController.jumpToTab(0);
        },
        title: 'My rides',
      ),
      body: (internet is NoInternet)
          ? const NoInternetWidget()
          : Stack(
              children: [
                //background blue container
                SingleChildScrollView(
                  controller: backgroundScrollController,
                  child: Column(
                    children: [
                      Container(
                        height: 230,
                        width: double.infinity,
                        color: HcTheme.blueColor,
                      ),
                      SizedBox(
                        height: size.height,
                      )
                    ],
                  ),
                ),
                //Forground data view
                MyRidesData(
                  sliverScrollController: sliverScrollController,
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    sliverScrollController.removeListener(_scrollListener);
    backgroundScrollController.dispose();
    sliverScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (sliverScrollController.position.pixels >= 0) {
      backgroundScrollController.jumpTo(sliverScrollController.position.pixels);
    }
  }
}
