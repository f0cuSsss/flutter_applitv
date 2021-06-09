import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("ic_launcher");

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future instantNotification() async {
    var android = AndroidNotificationDetails("id", "channel", "description");
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
      0,
      "Demo instant notificationq",
      "Tap to do something",
      platform,
      payload: "Welcome to demo app",
    );
  }

  Future imageNotification() async {
    var bigPicture = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("ic_launcher"),
      largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
      contentTitle: "Demo image notification",
      summaryText: "This is some text",
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    );

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);

    var platform = NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
      0,
      "Demo Image notificationq",
      "Tap to do something",
      platform,
      payload: "Welcome to demo app",
    );
  }
}
