import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:myflutter/models/Notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:myflutter/models/Notification.dart' as MODEL;

import 'package:myflutter/screens/VideoPlayerScreen.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print('Handling a background message');
  // print(message.data);
  // flutterLocalNotificationsPlugin.show(
  //     message.data.hashCode,
  //     message.data['title'],
  //     message.data['body'],
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         channel.id,
  //         channel.name,
  //         channel.description,
  //       ),
  //     ));

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
  // MODEL.Notification notification = null;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _topicButtonsDisabled = false;

  MODEL.Notification notif = null;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TextEditingController _topicController =
      TextEditingController(text: 'topic');

  Widget _buildPopupDialog(BuildContext context, MODEL.Notification notif) {
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
    var n = _parseToNotification(message);
    showDialog<bool>(
      context: context,
      builder: (_) => _buildPopupDialog(context, n),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToVideoPlayerByMessage(message);
      }
    });
  }

  void _setNotification(Map<String, dynamic> message) {
    var n = _parseToNotification(message);
    setState(() {
      notif = n;
    });
  }

  void _navigateToVideoPlayerByMessage(Map<String, dynamic> message) {
    final MODEL.Notification notif = _parseToNotification(message);
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          url: notif.videoUrl,
        ),
      ),
    );
  }

  void _navigateToVideoPlayerByData(MODEL.Notification n) {
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
            url: n.videoUrl,
          ),
        ));
  }

  MODEL.Notification _parseToNotification(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    // print("[Notification obj] ${notification}");
    // print("[data obj] ${data}");
    var n = MODEL.Notification(
      title: notification['title'],
      // description: notification['body'],
      bgImgUrl: data['bgImgUrl'],
      notifImgUrl: data['notifImgUrl'],
      videoUrl: data['videoUrl'],
    );
    return n;
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _setNotification(message);
        // _showItemDialog(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _navigateToVideoPlayerByMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToVideoPlayerByMessage(message);
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
    _firebaseMessaging.subscribeToTopic("applitv");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          notif != null
              ? SizedBox(width: 0, height: 0)
              : Center(
                  child: Column(
                  children: [
                    Expanded(
                      child: LoadingIndicator(
                        indicatorType: Indicator.pacman,
                        color: Colors.black,
                      ),
                    ),
                    Text('Waiting for notifications...',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2)
                  ],
                )),
          notif == null
              ? SizedBox(
                  width: 0,
                  height: 0,
                )
              : Positioned(
                  bottom: 35.0,
                  right: 30.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    // height: 130.0,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0)),
                          child: notif.notifImgUrl == null ||
                                  notif.notifImgUrl == ''
                              ? Image.asset(
                                  'assets/background_secondary.jpg',
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                )
                              : Image.network(
                                  notif.notifImgUrl,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: notif.title == null || notif.title == ''
                              ? Text(
                                  'Click',
                                  style: TextStyle(color: Colors.red[900]),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(notif.title),
                                    InkWell(
                                      onTap: () async {
                                        if (notif != null)
                                          _navigateToVideoPlayerByData(notif);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 0.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        child: Text(
                                          'OK',
                                          style: TextStyle(fontSize: 10.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
          Positioned(
            child: Text(
              notif == null || notif.timeLeft == null ? '' : notif.timeLeft,
              style: TextStyle(fontSize: 40),
            ),
            left: 20,
            top: 20,
          )
        ],
      ),
    );
  }
}
