import 'package:drmohans_homecare_flutter/common/controller/internet_connection_controller.dart';
import 'package:drmohans_homecare_flutter/features/auth/screens/screens/login.dart';
import 'package:drmohans_homecare_flutter/features/dashboard/dashboard.dart';
import 'package:drmohans_homecare_flutter/services/fcm_services.dart';
import 'package:drmohans_homecare_flutter/theme.dart';
import 'package:drmohans_homecare_flutter/utils/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'features/auth/controller/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await InternetController().checkInternet();
  // final PermissionStatus permission = await Permission.location.request();
  // print(">>>>>>>>>>>>>>>>>>>>>>>>>::::::::::::::::${permission.isGranted}");
  final token = await FirebaseMessaging.instance.getToken();
  print("token---------------------->$token");
  FcmServices()
    ..initLocalNotifications()
    ..initPushNotofications();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home care',
      theme: HcTheme.light(),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: StartupPage.route,
    );
  }
}

class StartupPage extends ConsumerWidget {
  static const route = '/';
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authProvider);
    switch (controller.runtimeType) {
      case LoggedInState:
        return const Dashboard();
      case AuthInitial:
      case LoggedOutState:
        return LoginScreen();
      case LoggedInErrorState:
        return LoginScreen();
      default:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }
}
