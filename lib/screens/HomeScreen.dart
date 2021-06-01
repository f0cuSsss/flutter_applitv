import 'package:flutter/material.dart';
import 'package:myflutter/models/NotificationItem.dart';
import 'package:myflutter/screens/DetailScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("[BG, contains key - data] ${data}");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print("[BG, contains key - notification] ${notification}");
  }

  print('Exception from bg');
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _topicButtonsDisabled = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TextEditingController _topicController =
      TextEditingController(text: 'topic');

  Widget _buildPopupDialog(BuildContext context, NotificationItem notif) {
    return AlertDialog(
      content: Text(notif.title),
      actions: <Widget>[
        FlatButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('Start the video'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildPopupDialog(context, _parseToNotification(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final NotificationItem notif = _parseToNotification(message);
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(notif),
        ));
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
  }

  NotificationItem _parseToNotification(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    print("[Notification obj] ${notification}");
    print("[data obj] ${data}");
    return NotificationItem(
      title: notification['title'],
      description: notification['body'],
      bgImgUrl: data['bgImgUrl'],
      notifImgUrl: data['notifImgUrl'],
      videoUrl: data['videoUrl'],
    );
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showItemDialog(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });
    _firebaseMessaging.subscribeToTopic("matchscore");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applitv'),
      ),
      body: Center(
        child: Text('Waiting for notifications...'),
      ),
    );
  }
}
