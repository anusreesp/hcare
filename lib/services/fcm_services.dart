import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmServices {
  final firebaseMessaging = FirebaseMessaging.instance;
  final andoidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notofications',
    description: 'This channel is used for important notification',
    importance: Importance.defaultImportance,
  );
  final localNotifications = FlutterLocalNotificationsPlugin();

  void hadleMessage(
    RemoteMessage? message,
  ) {
    print(message);
    if (message == null) return;
    // navigatorKey.currentState?.push(MaterialPageRoute(
    //     builder: ((ctx) => MessageScreen(
    //           message: message,

    //         ))));
  }

  //-------------------------Init Fcm notification--------------
  Future initPushNotofications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then((value) => hadleMessage(
          value,
        ));
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        hadleMessage(
          event,
        );
        //log(event.toString());
      },
    );
    // FirebaseMessaging.onBackgroundMessage(handleBagroundMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if (notification == null) {
        return;
      } else {
        localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                andoidChannel.id,
                andoidChannel.name,
                channelDescription: andoidChannel.description,
                icon: '@drawable/launcher_icon',
              ),
            ),
            payload: jsonEncode(event.toMap()));
      }
    });
  }

  Future initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/launcher_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
        final message = RemoteMessage.fromMap(jsonDecode(payload!));
        hadleMessage(
          message,
        );
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final message = RemoteMessage.fromMap(jsonDecode(details.payload!));
        hadleMessage(message);
      },
    );

    final platform = localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(andoidChannel);
  }

  Future<void> handleBagroundMessage(RemoteMessage message) async {
    print('title:${message.notification?.title}');
    print('title:${message.notification?.body}');
    print('title:${message.data}');
  }
}
