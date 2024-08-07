import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/authentication_service.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
  // Handle the message here...
}

// final _authService = locator<AuthenticationService>();

class FirebaseApi {
  final _authService = locator<AuthenticationService>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notification',
      description: 'This channel is used for important notifications',
      importance: Importance.defaultImportance);

  final localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
  }

  Future initLocalNotofications() async {
    const android = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const darwin = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: darwin);

    await localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
          handleMessage(message);
        }
      },
    );
    final platform = localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    AndroidFlutterLocalNotificationsPlugin();
    await platform?.createNotificationChannel(androidChannel);
  }

  Future initPushNotofications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      // final android = notification?.android;
      if (notification == null) return;

      localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                androidChannel.id, androidChannel.name,
                channelDescription: androidChannel.description,
                icon: '@mipmap/launcher_icon'),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future<void> initNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    final token = await _firebaseMessaging.getToken();
    prefs.setString('device_token', token ?? '');
    // final message = await _authService.addUserDeviceToken(deviceToken: token!);
    print('Token : $token');
    // print('message: $message');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initPushNotofications();

    initLocalNotofications();
  }
}
