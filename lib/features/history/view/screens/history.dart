import 'package:drmohans_homecare_flutter/common/controller/internet_connection_controller.dart';
import 'package:drmohans_homecare_flutter/common/widgets/no_internet_widget.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/dashboard.dart';
import 'package:drmohans_homecare_flutter/features/history/controller/history_col_de_controller.dart';
import 'package:drmohans_homecare_flutter/features/history/controller/history_controller.dart';
import 'package:drmohans_homecare_flutter/features/history/controller/history_filter_controller.dart';

import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/helper_fuctions/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/main_appbar.dart';

import '../components/history_completed_data.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with HelperFunctions {
  final ScrollController sliverScrollController = ScrollController();
  final ScrollController backgroundScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    sliverScrollController.addListener(_scrollListener);
  }

  void getData() {
    final filterSelected = ref.watch(historyFilterProvider);

    final dates = getFromAndToDate(filterSelected);
    final type = ref.watch(historyCollectionOrDeliveryController);

    ref.read(historyProvider.notifier).getHistoryData(
          fromDate: dates["FromDate"]!,
          toDate: dates["ToDate"]!,
          type: type,
        );
  }

  @override
  Widget build(BuildContext context) {
    getData();
    Size size = MediaQuery.of(context).size;
    final internet = ref.watch(internetProvider);
    return Scaffold(
      appBar: MainAppbar(
        onBackButtonPressed: () {
          tabController.jumpToTab(0);
        },
        title: "History",
        showBackButton: true,
      ),
      body: (internet is NoInternet)
          ? const NoInternetWidget()
          : Stack(
              children: [
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
                HistoryDataWidget(
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
