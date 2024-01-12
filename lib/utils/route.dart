import 'package:drmohans_homecare_flutter/features/auth/screens/screens/forgot_password_screen.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/dashboard.dart';
import 'package:drmohans_homecare_flutter/features/delivery/screen/product_details.dart';
import 'package:drmohans_homecare_flutter/features/profile/screens/notification_screen.dart';
import 'package:drmohans_homecare_flutter/features/profile/screens/contact_support.dart';
import 'package:drmohans_homecare_flutter/features/profile/screens/profile_screen.dart';
import 'package:drmohans_homecare_flutter/main.dart';
import 'package:flutter/material.dart';
import '../features/auth/screens/screens/login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case StartupPage.route:
        return MaterialPageRoute(builder: (_) => const StartupPage());
      case Dashboard.route:
        return MaterialPageRoute(builder: (_) => const Dashboard());
      case LoginScreen.route:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      // case ForgotPasswordScreen.route:
      //   return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case ProductDetailsPage.route:
        return MaterialPageRoute(builder: (_) => ProductDetailsPage());
      // case VitalMeasurementScreen.route:
      //   return MaterialPageRoute(
      //       builder: (_) => const VitalMeasurementScreen());
      // case MarkItemCollectedScreen.route:
      //   return MaterialPageRoute(
      //       builder: (_) => const MarkItemCollectedScreen());
      case ProfileScreen.route:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case NotificationScreen.route:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      // case TripCompletedScreen.route:
      //   return MaterialPageRoute(builder: (_) => const TripCompletedScreen());
      case ContactSupportScreen.route:
        return MaterialPageRoute(builder: (_) => const ContactSupportScreen());
      // case CollectionUserDetails.route:
      //   return MaterialPageRoute(builder: (_) => CollectionUserDetails(rideItemDetails: null,));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text(
                    "No route found \n${settings.name}",
                    textAlign: TextAlign.center,
                  )),
                ));
    }
  }
}
