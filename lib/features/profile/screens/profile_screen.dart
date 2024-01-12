import 'package:drmohans_homecare_flutter/common/controller/punch_in_function.dart';
import 'package:drmohans_homecare_flutter/common/profile_icon.dart';
import 'package:drmohans_homecare_flutter/features/auth/screens/screens/login.dart';
import 'package:drmohans_homecare_flutter/features/profile/screens/notification_screen.dart';
import 'package:drmohans_homecare_flutter/features/profile/controller/profile_controller.dart';
import 'package:drmohans_homecare_flutter/features/profile/controller/punch_out_controller.dart';
import 'package:drmohans_homecare_flutter/features/profile/screens/contact_support.dart';
import 'package:drmohans_homecare_flutter/features/profile/screens/widgets/punching_button.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../common/widgets/bottom_sheet.dart';
import '../../../common/widgets/grey_container.dart';
import '../../../common/widgets/icon_text.dart';
import '../../../common/widgets/main_background.dart';
import '../../../utils/location_service.dart';
import '../../auth/controller/auth_controller.dart';
import '../../dashboard/controller/start_end_ride_controller.dart';

class ProfileScreen extends ConsumerWidget {
  static const route = '/profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await ref.read(profileProvider.notifier).getProfile();
    });
    final size = MediaQuery.of(context).size;
    final punchOut = ref.watch(punchOutProvider);
    final latLong = ref.watch(locationServiceProvider);
    final isPunched = ref.watch(isPunchedIn);
    final punchedOut = ref.watch(isPunchedOut);
    final locationService = ref.watch(locationServiceProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: HcTheme.whiteColor,
            )),
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: MainBackgroundComponent(
            stops: const [0.18, 0.18],
            child: Container(
                height: size.height,
                padding: const EdgeInsets.all(12.0),
                child: Consumer(
                  builder: (context,ref,_) {
                    final profileData = ref.watch(profileProvider);
                    return Column(
                      children: [
                        if (profileData is ProfileSuccess)
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    // CircleAvatar(
                                    //   radius: 50,
                                    //   child:
                                    ProfileIconsComponent(
                                        image:
                                            profileData.profileData.photoUrl ?? "",
                                        radius: 50),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profileData.profileData.empName ?? "",
                                          style: mon18white,
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/icons/svg/profile/phone.svg"),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              profileData.profileData.mobile ?? "",
                                              style: mon12White,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/icons/svg/profile/mail.svg"),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              profileData.profileData.email ?? "",
                                              style: mon12White,
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.065,
                                ),

                                //--------------------------Address-----------------------------
                                const Text(
                                  'Address',
                                  style: mon16BlackSB,
                                ),

                                const SizedBox(
                                  height: 4,
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                        "assets/icons/svg/profile/location.svg"),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.80,
                                      child: Text(
                                        profileData.profileData.address ?? "",
                                        style: mon12Black,
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(
                                  height: 12,
                                ),

                                //--------------------------- Punched in---------------------------
                                Visibility(
                                          visible: isPunched == true,
                                          replacement: PunchButton(
                                            onPressed: () async{
                                              final latlong = await latLong.getLatLong();
                                              final locationData = await locationService.getLocation(latlong['lat'],latlong['long']);
                                              final LocationPermission permission = await Geolocator.checkPermission();
                                              if(permission == LocationPermission.values || permission == LocationPermission.whileInUse){
                                                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                                              }
                                              if (isPunched == true) {
                                                await ref
                                                    .read(tripStatusProvider.notifier)
                                                    .startOrEndTrip(
                                                    locationData?.address ?? "",
                                                    "0",
                                                    latlong['lat'].toString(),
                                                    latlong['long'].toString(),null);
                                              } else {
                                                punchIn(context);
                                              }
                                            },
                                            title: "Punch In",
                                            icon: 'profile/punchInUser',
                                            subtitle: 'Punch In to start your day',
                                            buttonTitle: 'Punch In',
                                          ),
                                          child: PunchedInTab(
                                            title: 'Punched in',
                                            time: profileData.profileData.punchInTime !=
                                                    null
                                                ? 'Today at ${DateFormat('hh : mm a').format(profileData.profileData.punchInTime!)}'
                                                : "",
                                            address:
                                                profileData.profileData.punchInAddr ?? "",
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Visibility(
                                          visible: isPunched == false && punchedOut == false,
                                          replacement:punchOut is PunchOutLoading ? Padding(
                                                      padding: const EdgeInsets.all(20.0),
                                                      child:  Center( child: LoadingAnimationWidget.staggeredDotsWave(color: HcTheme.greenColor, size: 38)),
                                                    ) : isPunched == true && punchedOut == false ? PunchButton(
                                                onPressed: ()async {
                                                 await ref.watch(punchOutProvider.notifier).punchOut(context);
                                                },
                                                title: 'Punch out',
                                                icon: 'profile/punchOutUser',
                                                subtitle: 'Punch out to end your day',
                                                buttonTitle: 'Punch out',
                                              ) :  PunchedInTab(
                                                title: 'Punched out',
                                                time: profileData.profileData.punchOutTime !=
                                                    null
                                                    ? 'Today at ${DateFormat('hh : mm a').format(profileData.profileData.punchOutTime!)}'
                                                    : "",
                                                address:
                                                profileData.profileData.punchOutAddr ?? "",
                                              ),
                                          child: const SizedBox.shrink()),
                                //------------------------Trips Completed ------------------------------
                                const SizedBox(
                                  height: 4,
                                ),
                                //----------------------------Notifications--------------------------
                                InkWell(
                                  onTap: () {
                                    // Navigator.pushNamed(context, NotificationScreen.route);
                                    pushNewScreen(context,
                                        screen: const NotificationScreen());
                                  },
                                  child: GreyCard(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 18),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                const IconText(
                                                    iconPath:
                                                        'profile/notifications',
                                                    title: 'Notifications',
                                                    style: mon14BlackSB),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 2.0),
                                                  child: SvgPicture.asset(
                                                      "assets/icons/svg/profile/right_arrow.svg"),
                                                ),
                                              ]))),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                //------------------------Contact support------------------------------
                                InkWell(
                                  onTap: () {
                                    // Navigator.pushNamed(context, ContactSupportScreen.route);
                                    pushNewScreen(context,
                                        screen: const ContactSupportScreen());
                                  },
                                  child: GreyCard(
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 18),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                const IconText(
                                                    iconPath:
                                                        'profile/customer_support',
                                                    title: 'Contact support',
                                                    style: mon14BlackSB),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 2.0),
                                                  child: SvgPicture.asset(
                                                      "assets/icons/svg/profile/right_arrow.svg"),
                                                ),
                                              ]))),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                //---------------------------Log Out---------------------------

                                InkWell(
                                  onTap: () async {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            topLeft: Radius.circular(12),
                                          ),
                                        ),
                                        builder: (BuildContext context) {
                                          return ActionOrCancelBottomSheet(
                                              title: 'Sure you want to logout?',
                                              greenButtonText: 'LOGOUT',
                                              whiteButtonText: 'CANCEL',
                                              greenButtononPressed: () async {
                                                ref
                                                    .read(authProvider.notifier)
                                                    .logout()
                                                    .then((value) {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  LoginScreen()));
                                                });
                                              },
                                              whiteButtononPressed: () {});
                                        });
                                  },
                                  child: const GreyCard(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 18),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                IconText(
                                                  iconPath: 'profile/logout',
                                                  title: 'Logout',
                                                  style: mon14BlackSB,
                                                )
                                              ]))),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                //------------------------------------------------------
                              ]),
                        if (profileData is! ProfileSuccess)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    );
                  }
                ))),
      ),
    );
  }
}
