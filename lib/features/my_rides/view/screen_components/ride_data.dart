import 'package:drmohans_homecare_flutter/common/controller/main_popup_controller.dart';
import 'package:drmohans_homecare_flutter/common/controller/punch_in_function.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_trip_controller.dart';
import 'package:drmohans_homecare_flutter/features/delivery/screen/product_details.dart';
import 'package:drmohans_homecare_flutter/common/widgets/trip_type_container_component.dart';
import 'package:drmohans_homecare_flutter/features/collection/screens/collection_user_details.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/ride_filter_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/controllers/sort_by_time_controller.dart';
import 'package:drmohans_homecare_flutter/features/my_rides/view/screen_components/sort_by_leading.dart';
import 'package:drmohans_homecare_flutter/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../../common/data/models/ride_item.dart';
import '../../../../common/widgets/main_popup_menu_button.dart';
import '../../../../common/widgets/space.dart';
import '../../../../common/widgets/trip_tile_card_widget/trip_tile_card.dart';
import '../../../../theme.dart';
import '../../controllers/collection_or_delivery_controller.dart';
import '../../controllers/rides_controller.dart';
import '../widgets/export_my_ride_components.dart';

class MyRidesData extends ConsumerWidget {
  const MyRidesData({
    super.key,
    required this.sliverScrollController,
  });
  final ScrollController sliverScrollController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<RideItem> rideDataList = [];
    final sortby = ref.watch(sortByTimeController);
    final ridesData = ref.watch(ridesProvider);
    final isPunched = ref.watch(isPunchedIn);

    //sorting data based on time ascending or descending
    if (ridesData is RidesData) {
      rideDataList = ridesData.data.rideList;
      if (sortby != null) {
        if (sortby == 'Time Ascending') {
          rideDataList.sort(
            (a, b) => a.date!.compareTo(b.date!),
          );
        } else {
          rideDataList.sort(
            (a, b) => b.date!.compareTo(a.date!),
          );
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomScrollView(
        controller: sliverScrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Category',
                      style: mon16WhiteSBold,
                    ),
                    MainPopupMenuButton(
                      provider: collectionFilter,
                      iconColor: HcTheme.white1Color,
                      icon: SvgPicture.asset('assets/icons/svg/filter.svg',
                          colorFilter: const ColorFilter.mode(
                              HcTheme.whiteColor, BlendMode.srcIn)
                          // color: HcTheme.whiteColor,
                          ),
                      label: "Filter",
                      items: const [
                        "Today",
                        "Tomorrow",
                        "Yesterday",
                        "Last 7 days",
                        "Last 30 days"
                      ],
                      onPopupSelected: (value) {
                        ref.read(rideFilterProvider.notifier).state = value;
                      },
                    )
                  ],
                ),
                Space.y(15),
                TabComponent(
                  tabLabelList: ridesData is RidesData
                      ? [
                          "Assigned(${ridesData.data.assigned})",
                          "Pending(${ridesData.data.pending})",
                          "Rescheduled(${ridesData.data.rescheduled})",
                          "Unscheduled(${ridesData.data.unscheduled})"
                        ]
                      : [
                          "Assigned(0)",
                          "Pending(0)",
                          "Rescheduled(0)",
                          "Unscheduled(0)"
                        ],
                ),
                Space.y(15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SortbyRowLeadingComponent(
                      items: ridesData is RidesData
                          ? [
                              "Assigned Rides(${ridesData.data.assigned})",
                              "Pending Rides(${ridesData.data.pending})",
                              "Rescheduled Rides(${ridesData.data.rescheduled})",
                              "Unscheduled Trips(${ridesData.data.unscheduled})"
                            ]
                          : [
                              "Assigned Rides(0)",
                              "Pending Rides(0)",
                              "Rescheduled Rides(0)",
                              "Unscheduled Trips(0)"
                            ],
                    ),
                    MainPopupMenuButton(
                      provider: collectionSort,
                      noInitial: true,
                      onPopupSelected: (value) {
                        ref.read(sortByTimeController.notifier).state = value;
                      },
                      items: const ["Time Ascending", "Time descending"],
                      icon: SvgPicture.asset(
                        'assets/icons/svg/sort.svg',
                        colorFilter: const ColorFilter.mode(
                          HcTheme.whiteColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: "Sort by",
                    )
                  ],
                ),
                Space.y(20),
                _buildCollectionDeliveryButtonRow(context, ref),
                // Space.y(10),
              ],
            ),
          ),
          //If any error occur then shows the error message
          if (ridesData is RidesError)
            _buildErrorOrEmptyMessage(context, ridesData.errorMsg),
          //Initially show loading
          if (ridesData is RidesInitial) _buildLoading(context),
          if (ridesData is RidesData)
            // if the data is empty, show the empty message
            rideDataList.isEmpty
                ? _buildErrorOrEmptyMessage(context, "Ride list is empty")
                //if data is not empty then show the list
                : _buildRideList(rideDataList, isPunched),
        ],
      ),
    );
  }

  Row _buildCollectionDeliveryButtonRow(BuildContext context, WidgetRef ref) {
    final collOrDelvry = ref.watch(collectionOrDeliveryController);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TripTypeContainerComponent(
          icon: "collection_card_tag.svg",
          title: 'COLLECTIONS',
          isActive: collOrDelvry == "All" || collOrDelvry == "Collection",
          onTap: () {
            if (collOrDelvry == "All") {
              ref.read(collectionOrDeliveryController.notifier).state =
                  "Delivery";
            }
            if (collOrDelvry == "Delivery") {
              ref.read(collectionOrDeliveryController.notifier).state = "All";
            }
          },
        ),
        TripTypeContainerComponent(
          icon: "delivery_card_tag.svg",
          title: 'DELIVERIES',
          isActive: collOrDelvry == "All" || collOrDelvry == "Delivery",
          onTap: () {
            if (collOrDelvry == "All") {
              ref.read(collectionOrDeliveryController.notifier).state =
                  "Collection";
            }
            if (collOrDelvry == "Collection") {
              ref.read(collectionOrDeliveryController.notifier).state = "All";
            }
          },
        )
      ],
    );
  }

  SliverList _buildRideList(List<RideItem> rideDataList, bool isPunched) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Consumer(builder: (context, ref, child) {
            final tripStart = ref.watch(tripStartProvider);
            return TripCardTile(
              rideItem: rideDataList[index],
              onViewDetailsClick: () {
                // should be edit based on the data from api
                // if ((index % 2 != 0)) {

                if (isPunched == true) {
                  if (tripStart == true) {
                    if (rideDataList[index].hcType != 'Collection') {
                      pushNewScreen(context,
                          screen: ProductDetailsPage(
                            orderId: rideDataList[index].orderId,
                            type: rideDataList[index].hcType,
                          ));
                    } else {
                      pushNewScreen(context,
                          screen: CollectionUserDetails(
                            // rideItemDetails: rideDataList[index],
                            orderId: rideDataList[index].orderId,
                            type: rideDataList[index].hcType,
                          ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Start trip to continue'),
                        backgroundColor: HcTheme.greenColor,
                      ),
                    );
                  }
                } else {
                  punchIn(context);
                }
              },
            );
          });
        },
        childCount: rideDataList.length,
      ),
    );
  }

  SliverToBoxAdapter _buildLoading(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildErrorOrEmptyMessage(
      BuildContext context, String message) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
