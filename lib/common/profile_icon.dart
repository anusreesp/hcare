import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileIconsComponent extends StatelessWidget {
  final double radius;
  final String image;
  const ProfileIconsComponent(
      {Key? key, required this.image, required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius,
        child: image != ""
            ? Image.network(
                image,
                fit: BoxFit.cover,
              )
            : SvgPicture.asset(
                'assets/icons/svg/profile_avatar.svg',
                width: radius * 2,
              ));
  }
}
