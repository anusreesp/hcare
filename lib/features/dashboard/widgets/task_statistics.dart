import 'package:drmohans_homecare_flutter/features/dashboard/dashboard.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/data/models/dashboard_model.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/widgets/statistics_button.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/tab_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskStatistics extends ConsumerWidget {
  final DashboardModel dashboardData;
  const TaskStatistics({super.key, required this.dashboardData});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
      margin: const EdgeInsets.only(top: 22, bottom: 22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                const Color(0xFF152E69)
              ])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics of the day',
            style: mon12White,
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatisticsButton(
                count: dashboardData.assigned,
                title: 'Assigned',
                svgIcon: 'assets/icons/svg/assigned.svg',
                onTap: () {
                  tabController.jumpToTab(1);
                  ref.read(myRidesScreenTabController.notifier).state = 0;
                },
              ),
              Container(
                height: 60,
                width: 0.6,
                color: Colors.white,
              ),
              StatisticsButton(
                count: dashboardData.pending,
                title: 'Pending Trips',
                svgIcon: 'assets/icons/svg/pending.svg',
                onTap: () {
                  tabController.jumpToTab(1);
                  ref.read(myRidesScreenTabController.notifier).state = 1;
                },
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatisticsButton(
                count: dashboardData.unscheduled,
                title: 'Unscheduled',
                svgIcon: 'assets/icons/svg/unscheduled.svg',
                onTap: () {
                  tabController.jumpToTab(1);
                  ref.read(myRidesScreenTabController.notifier).state = 3;
                },
              ),
              Container(
                height: 60,
                width: 0.6,
                color: Colors.white,
              ),
              StatisticsButton(
                count: dashboardData.rescheduled,
                title: 'Rescheduled',
                svgIcon: 'assets/icons/svg/rescheduled.svg',
                onTap: () {
                  tabController.jumpToTab(1);
                  ref.read(myRidesScreenTabController.notifier).state = 2;
                },
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }
}
