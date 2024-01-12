import 'dart:developer';

import 'package:drmohans_homecare_flutter/common/controller/internet_connection_controller.dart';
import 'package:drmohans_homecare_flutter/common/controller/main_popup_controller.dart';
import 'package:drmohans_homecare_flutter/common/controller/punch_in_function.dart';
import 'package:drmohans_homecare_flutter/common/widgets/bottom_sheet.dart';
import 'package:drmohans_homecare_flutter/common/widgets/no_internet_widget.dart';
import 'package:drmohans_homecare_flutter/features/collection/screens/collection_user_details.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/dashboard_trip_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/home_filter_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/home_sort_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/controller/start_end_ride_controller.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/widgets/task_statistics.dart';
import 'package:drmohans_homecare_flutter/features/delivery/screen/product_details.dart';
import 'package:drmohans_homecare_flutter/features/profile/controller/profile_controller.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/helper_fuctions/helper.dart';
import 'package:drmohans_homecare_flutter/utils/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../common/data/models/ride_item.dart';
import '../../../common/widgets/grey_container.dart';
import '../../../common/widgets/main_appbar.dart';
import '../../../common/widgets/main_green_button.dart';
import '../../../common/widgets/main_popup_menu_button.dart';
import '../../../common/widgets/trip_tile_card_widget/trip_tile_card.dart';
import '../controller/version_update_controller.dart';

// final scaffoldKey = GlobalKey<ScaffoldState>();

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with HelperFunctions {
  @override
  Widget build(
    BuildContext context,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final filterType = ref.watch(homeFilterProvider);
      final selectedDate = getFromAndToDate(filterType);
      ref.read(dashboardProvider.notifier).init(
          fromDate: selectedDate["FromDate"]!, toDate: selectedDate['ToDate']!);
      bool permission = await Permission.location.isGranted;
      if (!permission) {
        ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
            content: const Text("Enable location permission"),
            backgroundColor: Colors.amber,
            actions: [
              MaterialButton(
                onPressed: () async {
                  await Permission.location.request().then((value) {
                    if (value.isGranted) {
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    }
                  });
                },
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border.all(color: HcTheme.blackColor),
                        borderRadius: BorderRadius.circular(4)),
                    child: const Text("Enable")),
              )
            ]));
      }
    });
    final internet = ref.watch(internetProvider);
    if (internet is Connected) {
      log('Connected');
    }
    if (internet is NoInternet) {
      log('No internet');
    }

    ref.listen(tripStatusProvider, (previous, next) {
      if (next is TripStatusSuccess) {
        if (next.isTripStart) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Trip Started."),
            backgroundColor: HcTheme.greenColor,
            duration: Duration(milliseconds: 1200),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Trip Ended."),
            backgroundColor: HcTheme.greenColor,
            duration: Duration(milliseconds: 1200),
          ));
        }
      }
    });
    return Scaffold(
      // key: scaffoldKey,
      appBar: MainAppbar(
        onBackButtonPressed: () {},
        title: 'Dashboard',
        showBackButton: false,
      ),
      body: (internet is NoInternet)
          ? const NoInternetWidget()
          : Consumer(builder: (context, ref, child) {
              ref.listen(versionUpdateProvider, (previous, next) {
                if (next is VersionUpdateLoaded) {
                  if (next.res['Update'] == "1" ||
                      next.res['ForceUpdate'] == "1") {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return PopScope(
                              onPopInvoked: (_) async {},
                              child: AlertDialog(
                                title: const Text("Update app"),
                                content: const Text(
                                    "You are currently using older version. Kindly Update the app to continue"),
                                actions: [
                                  next.res['ForceUpdate'] == "0"
                                      ? TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Close"),
                                        )
                                      : const SizedBox.shrink(),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text("Update"),
                                  )
                                ],
                              ));
                        });
                  }
                }
              });
              final dashboardController = ref.watch(dashboardProvider);
              final rideListController = ref.watch(homeSortListProvider);
              final latLong = ref.watch(locationServiceProvider);

              // final tripStatus = ref.watch(tripStatusProvider);
              // final tripStart = ref.watch(tripStartProvider);
              // final tripEnd = ref.watch(tripEndProvider);
              final isPunched = ref.watch(isPunchedIn);
              if (dashboardController is DashboardLoaded) {
                final dashData = dashboardController.dashboardData;
                print("trip id------>   ${dashData.tripId}");
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  ref.read(tripIdProvider.notifier).state = dashData.tripId;
                  ref.read(tripStartProvider.notifier).state =
                      dashData.tripStartSts == 'True' ? true : false;
                  ref.read(tripEndProvider.notifier).state =
                      dashData.tripEndSts == 'False' ? false : true;
                  ref.read(isPunchedIn.notifier).state =
                      dashData.punchInStatus == 'true' ? true : false;
                  ref.read(isPunchedOut.notifier).state =
                      dashData.punchOutStatus == 'true' ? true : false;
                });
                double linearprogress = double.parse(dashData.pending) == 0
                    ? 0.0
                    : double.parse(dashData.completed) /
                        double.parse(dashData.assigned);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Ready to start your trip?',
                                style: mon18BlackSB,
                              ),
                              const Spacer(),
                              MainPopupMenuButton(
                                onPopupSelected: (value) {
                                  ref.read(homeFilterProvider.notifier).state =
                                      value;
                                  debugPrint("++++++++ $value");
                                },
                                items: const [
                                  'Today',
                                  'Tomorrow',
                                  'Yesterday',
                                  'Last 7 days',
                                  'Last 30 days'
                                ],
                                icon: SvgPicture.asset(
                                    'assets/icons/svg/filter.svg'),
                                iconColor: HcTheme.greenColor,
                                label: 'Filter',
                                labelTextStyle: mon16Black,
                                provider: homeFilter,
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: isPunched != true,
                          child: GreyCard(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            margin: const EdgeInsets.only(
                                top: 14, left: 4, right: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Punch in*',
                                  style: mon14BlackSB,
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 4, 0, 8),
                                  child: Text(
                                    'Click your picture to get started with the trips',
                                    style: mon12lightGrey3,
                                  ),
                                ),
                                MainGreenButton(
                                  title: 'CLICK YOUR PICTURE',
                                  iconName: 'camera_green',
                                  textStyle: mon12BlackSB,
                                  height: 38,
                                  onPressed: () async {
                                    punchIn(context);
                                  },
                                  outlined: true,
                                )
                              ],
                            ),
                          ),
                        ),
                      ])),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        ///Blue box for statics
                        TaskStatistics(
                          dashboardData: dashboardController.dashboardData,
                        ),

                        // Text('Trip for the day', style: mon16BlackSB,),
                        //
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 16),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       SelectionCheckbox(onTap: (){}, isActive: true),
                        //       SelectionCheckbox(onTap: (){}, isActive: false),
                        //     ],
                        //   ),
                        // )

                        ///Rides start section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Rides for the day',
                                  style: mon18BlackSB,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/svg/calendar2.svg'),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      DateFormat('dd MMM yyyy')
                                          .format(DateTime.now()),
                                      style: mon12lightGrey3,
                                    )
                                  ],
                                ),
                              ],
                            ),

                            ///Button
                            // if (tripStatus is TripStatusLoading)
                            //   const Center(
                            //     child: CircularProgressIndicator(),
                            //   ),
                            // if (tripStatus is! TripStatusLoading)
                            Consumer(builder: (context, ref, _) {
                              final tripStatus = ref.watch(tripStatusProvider);
                              final tripLoading =
                                  ref.watch(tripLoadingProvider);
                              final tripStart = ref.watch(tripStartProvider);
                              final tripEnd = ref.watch(tripEndProvider);
                              final locationService =
                                  ref.watch(locationServiceProvider);
                              final id = ref.watch(tripIdProvider);
                              print("start------------>  $tripStart");
                              if (tripLoading) {
                                return LoadingAnimationWidget.staggeredDotsWave(
                                    color: HcTheme.greenColor, size: 32);
                              } else {
                                return InkWell(
                                  onTap: () async {
                                    if (tripStart == true) {
                                      ref
                                          .read(tripLoadingProvider.notifier)
                                          .state = true;
                                      final latlong =
                                          await latLong.getLatLong();
                                      final locationData =
                                          await locationService.getLocation(
                                              latlong['lat'], latlong['long']);
                                      await ref
                                          .read(tripStatusProvider.notifier)
                                          .startOrEndTrip(
                                              locationData?.address ?? "",
                                              "1",
                                              latlong['lat'].toString(),
                                              latlong['long'].toString(),
                                              id)
                                          .then((value) {
                                        ref
                                            .read(tripEndProvider.notifier)
                                            .state = false;
                                        ref
                                            .read(tripStartProvider.notifier)
                                            .state = false;
                                      });
                                    } else if (tripEnd == false &&
                                        isPunched == true) {
                                      ref
                                          .read(tripLoadingProvider.notifier)
                                          .state = true;
                                      final latlong =
                                          await latLong.getLatLong();
                                      final locationData =
                                          await locationService.getLocation(
                                              latlong['lat'], latlong['long']);
                                      await ref
                                          .read(tripStatusProvider.notifier)
                                          .startOrEndTrip(
                                              locationData?.address ?? "",
                                              "0",
                                              latlong['lat'].toString(),
                                              latlong['long'].toString(),
                                              null)
                                          .then((value) {
                                        ref
                                            .read(tripStartProvider.notifier)
                                            .state = true;
                                        if (tripStatus is TripStatusSuccess) {
                                          ref
                                                  .read(tripIdProvider.notifier)
                                                  .state =
                                              tripStatus?.tripId ?? "0";
                                        }
                                      });
                                    } else {
                                      punchIn(context);
                                    }
                                  },
                                  child: Container(
                                    height: 42,
                                    width: 138,
                                    decoration: BoxDecoration(
                                        color: tripStart != true
                                            ? HcTheme.lightGreen2Color
                                            : HcTheme.whiteColor,
                                        borderRadius: BorderRadius.circular(50),
                                        border: tripStart == true
                                            ? Border.all(
                                                width: 2,
                                                color: HcTheme.greenColor)
                                            : null),
                                    child: Center(
                                        child: Text(
                                      tripStart == false && tripEnd == false
                                          ? 'Start Trip'
                                          : 'End Trip',
                                      style: mon14BlackSB,
                                    )),
                                  ),
                                );
                              }
                            }),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 8),
                          child: RichText(
                              text: TextSpan(
                                  text:
                                      '${dashboardController.dashboardData.completed} / ${dashboardController.dashboardData.assigned}',
                                  style: mon30BlueBold,
                                  children: const [
                                TextSpan(
                                    text: '  rides done',
                                    style: mon12lightGrey3)
                              ])),
                        ),

                        LinearProgressIndicator(
                          value: linearprogress,
                          borderRadius: BorderRadius.circular(10),
                          color: HcTheme.lightGreen2Color,
                          backgroundColor: HcTheme.lightGrey1Color,
                          minHeight: 6,
                        ),

                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: MainPopupMenuButton(
                                provider: homeSort,
                                onPopupSelected: (value) {
                                  ref
                                      .read(homeSortListProvider.notifier)
                                      .sortRideItem(value);
                                },
                                items: const [
                                  'Time ascending',
                                  'Completed',
                                  'Pending'
                                ],
                                icon: SvgPicture.asset(
                                    'assets/icons/svg/sort.svg'),
                                iconColor: HcTheme.greenColor,
                                label: 'Sort by',
                                labelTextStyle: mon16Black,
                              ),
                            ))
                      ])),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final RideItem tripDetails;
                          if (rideListController.isEmpty) {
                            tripDetails =
                                dashboardController.dashboardData.lst[index];
                          } else {
                            tripDetails = rideListController[index];
                          }

                          return Consumer(builder: (context, ref, _) {
                            final tripStart = ref.watch(tripStartProvider);
                            return TripCardTile(
                              rideItem: tripDetails,
                              onViewDetailsClick: () {
                                //----------------------Collection Details screen------------------

                                // if ((index % 2 != 0)) {
                                if (isPunched == true) {
                                  if (tripStart == true) {
                                    if (tripDetails.hcType == 'Delivery') {
                                      debugPrint(
                                          "~~~~~~~~~~~~~~~~~~~~~ ${tripDetails.orderId}");
                                      pushNewScreen(context,
                                          screen: ProductDetailsPage(
                                            type: tripDetails.hcType ?? "",
                                            orderId: tripDetails.orderId ?? "",
                                          ));
                                    } else {
                                      pushNewScreen(context,
                                          screen: CollectionUserDetails(
                                            type: tripDetails.hcType ?? "",
                                            orderId: tripDetails.orderId ?? "",
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
                            childCount:
                                dashboardController.dashboardData.lst.length),
                      ),
                    ],
                  ),
                );
              } else if (dashboardController is DashboardError) {
                return Center(
                    child: Text(
                  dashboardController.error,
                  textAlign: TextAlign.center,
                ));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
    );
  }
}
