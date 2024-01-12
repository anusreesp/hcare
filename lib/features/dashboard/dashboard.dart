import 'package:drmohans_homecare_flutter/features/dashboard/screens/home.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/widgets/nav_button.dart';
import 'package:drmohans_homecare_flutter/features/history/view/screens/history.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../my_rides/view/screen/my_rides_screen.dart';

final PersistentTabController tabController =
    PersistentTabController(initialIndex: 0);

class Dashboard extends StatelessWidget {
  static const route = '/dashboard';
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: tabController,
      screens: const [
        Home(),
        MyRidesScreen(),
        // History(),
        // HandoverDetails(),
        // MyRidesScreen(),
        // History(),
        // ProductDetailsPage(),
        HistoryScreen(),

        // VitalMeasurementScreen(),
        // CollectionScreen()
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: const NavButton(
            isActive: true,
            iconName: 'dash_home',
          ),
          inactiveIcon: const NavButton(
            isActive: false,
            iconName: 'dash_home',
          ),
        ),
        PersistentBottomNavBarItem(
          icon: const NavButton(
            isActive: true,
            iconName: 'dash_trips',
          ),
          inactiveIcon: const NavButton(
            isActive: false,
            iconName: 'dash_trips',
          ),
        ),
        PersistentBottomNavBarItem(
          icon: const NavButton(
            isActive: true,
            iconName: 'dash_history',
          ),
          inactiveIcon: const NavButton(
            isActive: false,
            iconName: 'dash_history',
          ),
        ),
      ],
      navBarStyle: NavBarStyle.simple,
    );
  }
}
