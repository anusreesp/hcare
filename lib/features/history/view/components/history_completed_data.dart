import 'package:drmohans_homecare_flutter/common/controller/main_popup_controller.dart';
import 'package:drmohans_homecare_flutter/common/widgets/green_border_button.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_trip_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/start_end_ride_controller.dart';
import 'package:drmohans_homecare_flutter/features/history/controller/history_col_de_controller.dart';
import 'package:drmohans_homecare_flutter/features/history/controller/history_controller.dart';
import 'package:drmohans_homecare_flutter/features/history/controller/history_filter_controller.dart';
import 'package:drmohans_homecare_flutter/features/history/data/models/history_model.dart';
import 'package:drmohans_homecare_flutter/features/history/view/screens/product_history_details.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../../common/data/models/ride_item.dart';
import '../../../../common/widgets/bottom_sheet.dart';
import '../../../../common/widgets/main_popup_menu_button.dart';
import '../../../../common/widgets/space.dart';
import '../../../../common/widgets/trip_tile_card_widget/trip_tile_card.dart';
import '../../../../common/widgets/trip_type_container_component.dart';
import '../screens/handover_details.dart';

class HistoryDataWidget extends ConsumerWidget {
  const HistoryDataWidget({
    super.key,
    required this.sliverScrollController,
  });

  final ScrollController sliverScrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripStart = ref.watch(tripStartProvider);
    final tripStatus = ref.watch(tripStatusProvider);
    final latLong = ref.watch(locationServiceProvider);
    final id = ref.watch(tripIdProvider);
    final history = ref.watch(historyProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomScrollView(
        controller: sliverScrollController,
        slivers: [
          //TODO: change the head component after clicking end ride button

          //Head section
          tripStart
              ? _buildHeadSection(context, ref, latLong, id, history)
              : _buildCompletedHeadSection(context),

          // Collection or deliver section containers
          _buildCollectionOrDeliverySelction(ref),
          if (history is HistoryInitial) _buildLoading(context),
          //Error
          if (history is HistoryError)
            _buildErrorOrEmptyMessage(context, history.error),
          //Build the list of ride details
          if (history is HistoryData)
            history.history.lst.isEmpty
                ? _buildErrorOrEmptyMessage(context, "No data found")
                : _buildRIdeList(!tripStart, history.history.lst),
        ],
      ),
    );
  }

  SliverList _buildRIdeList(bool isTripEnd, List<RideItem> data) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return TripCardTile(
            //TODO: modify the is completed value if api providing  the trip completed data

            rideItem: data[index],
            onViewDetailsClick: () {
              //TODO: navigate to Collection or deliver history details based on the data from api
              pushNewScreen(context,
                  screen: ProductDetailsHistory(
                    data: data[index],
                  ));
            },
          );
        },
        childCount: data.length,
      ),
    );
  }

  SliverToBoxAdapter _buildHeadSection(BuildContext context, WidgetRef ref,
      LocationService latLong, String id, HistoryState history) {
    final tripStatus = ref.watch(tripStatusProvider);
    final locationService = ref.watch(locationServiceProvider);
    int completed = 0;
    int total = 0;
    double progress = 0.0;
    if (history is HistoryData) {
      completed = int.parse(history.history.finishedCount ?? "0");
      total = int.parse(history.history.totalCount ?? "0");
      if (total != 0) {
        progress = completed / total;
      }
    }
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trips done for the day',
                style: mon14WhiteSB,
              ),
              MainPopupMenuButton(
                provider: historySort,
                icon: SvgPicture.asset(
                  'assets/icons/svg/filter.svg',
                  colorFilter: const ColorFilter.mode(
                      HcTheme.whiteColor, BlendMode.srcIn),
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
                  ref.read(historyFilterProvider.notifier).state = value;
                  // print(value);
                },
              )
            ],
          ),
          Space.y(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$completed/$total",
                    style: mon30GreenBold,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Text(
                      ' trips done',
                      style: mon12White,
                    ),
                  ),
                ],
              ),
              if (tripStatus is TripStatusLoading)
                LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white, size: 38)
              else
                GreenBorderButtonRounded(
                  child: const Text(
                    'End Trip',
                    style: mon14White,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return SuccessFailedBottomSheet(
                          title: "Trip Completed",
                          buttonText: "OKAY",
                          onPressed: () async {
                            Navigator.of(ctx).pop();
                            final latlong = await latLong.getLatLong();
                            final locationData = await locationService
                                .getLocation(latlong['lat'], latlong['long']);
                            await ref
                                .read(tripStatusProvider.notifier)
                                .startOrEndTrip(
                                    locationData?.address ?? "",
                                    "1",
                                    latlong['lat'].toString(),
                                    latlong['long'].toString(),
                                    id)
                                .then((value) {
                              ref.read(tripEndProvider.notifier).state = false;
                              ref.read(tripStartProvider.notifier).state =
                                  false;
                            });
                          },
                          content:
                              "Good job Gourav Joshi, Your Trip is completed",
                        );
                      },
                    );
                  },
                )
            ],
          ),
          Space.y(10),
          LinearProgressIndicator(
            value: progress,
            borderRadius: BorderRadius.circular(10),
            color: HcTheme.lightGreen2Color,
            minHeight: 6,
          ),
          Space.y(20),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildCollectionOrDeliverySelction(WidgetRef ref) {
    final collOrDelvry = ref.watch(historyCollectionOrDeliveryController);
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TripTypeContainerComponent(
            icon: "collection_card_tag.svg",
            title: 'COLLECTIONS',
            isActive: collOrDelvry == "All" || collOrDelvry == "Collection",
            onTap: () {
              if (collOrDelvry == "All") {
                ref.read(historyCollectionOrDeliveryController.notifier).state =
                    "Delivery";
              }
              if (collOrDelvry == "Delivery") {
                ref.read(historyCollectionOrDeliveryController.notifier).state =
                    "All";
              }
            },
          ),
          TripTypeContainerComponent(
            icon: "delivery_card_tag.svg",
            title: 'DELIVERIES',
            isActive: collOrDelvry == "All" || collOrDelvry == "Delivery",
            onTap: () {
              if (collOrDelvry == "All") {
                ref.read(historyCollectionOrDeliveryController.notifier).state =
                    "Collection";
              }
              if (collOrDelvry == "Collection") {
                ref.read(historyCollectionOrDeliveryController.notifier).state =
                    "All";
              }
            },
          )
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildCompletedHeadSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your trip has been completed',
            style: mon16White600,
          ),
          Space.y(10),
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                size: 14,
                color: HcTheme.white1Color.withOpacity(0.80),
              ),
              Text(
                '28 Feb 2023',
                style: mon12WhiteOpt80,
              ),
            ],
          ),
          Space.y(10),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const HandoverDetails(),
              ));
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: HcTheme.lightGreen2Color,
                  ),
                ),
              ),
              child: const Text(
                'View handover details',
                style: mon12LightGreen,
              ),
            ),
          ),
          Space.y(10),
        ],
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
