import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationHandler {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Private constructor
  FirebaseNotificationHandler._();

  // Singleton instance
  static final FirebaseNotificationHandler _instance =
      FirebaseNotificationHandler._();

  // Getter for the singleton instance
  static FirebaseNotificationHandler get instance => _instance;

  Future<void> initialize() async {
    // Request permission for receiving push notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Check if permission is granted
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for push notifications');
    } else {
      print(
          'User declined or hasn\'t accepted permission for push notifications');
    }

    // Configure handlers for receiving messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Configure token refresh handler
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      print('Token refreshed: $token');
    });
  }

  Future<String?> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('Token: $token');
    return token;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Handle the message here...
}
