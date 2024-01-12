import 'package:drmohans_homecare_flutter/common/profile_icon.dart';
import 'package:drmohans_homecare_flutter/features/profile/controller/profile_controller.dart';
import 'package:drmohans_homecare_flutter/features/profile/screens/profile_screen.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({
    super.key,
    this.onBackButtonPressed,
    required this.title,
    this.showBackButton = true,
  });
  final VoidCallback? onBackButtonPressed;
  final bool showBackButton;
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              onPressed: onBackButtonPressed,
              icon: const Icon(
                Icons.arrow_back,
                color: HcTheme.whiteColor,
              ),
            )
          : null,
      title: Text(title),
      actions: [
        InkWell(onTap: () {
          pushNewScreen(context, screen: const ProfileScreen());
        }, child: Consumer(builder: (context, ref, _) {
          final profileData = ref.watch(profileProvider);
          if (profileData is ProfileSuccess) {
            return ProfileIconsComponent(
                image: profileData.profileData.photoUrl ?? "", radius: 20);
          } else {
            return const ProfileIconsComponent(image: "", radius: 20);
          }
        })),
        const SizedBox(
          width: 12,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
