import 'package:Applitv/bloc/NotificationBloc.dart';
import 'package:Applitv/services/NotificationService.dart';
import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:Applitv/models/Notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:Applitv/models/Notification.dart' as Model;
import 'package:Applitv/screens/NoInternetScreen.dart';

import 'package:Applitv/screens/VideoPlayerScreen.dart';
import 'package:Applitv/utils/check_internet_connection.dart';
import 'package:Applitv/utils/config.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _topicButtonsDisabled = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TextEditingController _topicController =
      TextEditingController(text: 'topic');
  NotificationBloc notifBlock = NotificationBloc();

  void _navigateToVideoPlayerByData(Model.Notification n) {
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          url: Config.URL + n.videoUrl,
        ),
      ),
    );
  }

  Model.Notification _parseToNotification(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    // print("[Notification obj] ${notification}");
    // print("[data obj] ${data}");
    var n = Model.Notification(
      title: notification['title'],
      // description: notification['body'],
      bgImgUrl: data['bgImgUrl'],
      notifImgUrl: data['notifImgUrl'],
      videoUrl: data['videoUrl'],
    );
    return n;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: IsInternetConnected(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(width: 0, height: 0);
          }
          if (snapshot.data) {
            return _renderContent();
          } else {
            return NoInternetScreen();
          }
        },
      ),
    );
  }

  Widget _renderContent() {
    return StreamBuilder<Model.Notification>(
      stream: notifBlock.notifStream,
      builder: (context, snapshot) {
        print("snapshot: ${snapshot.data?.title}");

        if (snapshot.hasData) {
          Model.Notification notif = snapshot.data;
          print('snapshot has a data');
          if (notif.isEmpty) {
            print(
                '---[title]--- ${notif.title} [${notif.isTitleEmpty}] ----------');
            print(
                '---[bgImgUrl]--- ${notif.bgImgUrl} [${notif.isBgImgUrlEmpty}] ----------');
            print(
                '---[notifImgUrl]--- ${notif.notifImgUrl} [${notif.isNotifImgUrlEmpty}] ----------');
            print(
                '---[videoUrl]--- ${notif.videoUrl} [${notif.isVideoUrlEmpty}] ----------');
            print('nullable notification');
            return _renderWaitingForNotification();
          } else {
            Bringtoforeground.bringAppToForeground();
            print('notification with data');
            return _renderNotification(notif);
          }
        } else {
          print('snapshot has not a data');
          return _renderWaitingForNotification();
        }
      },
    );
  }

  Widget _renderWaitingForNotification() {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: LoadingIndicator(
              indicatorType: Indicator.pacman,
              color: Colors.black,
            ),
          ),
          Text(
            'Waiting for notifications...',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
        ],
      ),
    );
  }

  Widget _renderNotification(notification) {
    return Stack(
      children: [
        notification.bgImgUrl == null || notification.bgImgUrl == ''
            ? Image.asset(
                'assets/background_main.jpg',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              )
            : Image.network(
                notification.bgImgUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
        Positioned(
          bottom: 35.0,
          right: 30.0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0)),
                  child: notification.notifImgUrl == null ||
                          notification.notifImgUrl == ''
                      ? Image.asset(
                          'assets/background_secondary.jpg',
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        )
                      : Image.network(
                          notification.notifImgUrl,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: notification.title == null || notification.title == ''
                      ? Text(
                          'Click',
                          style: TextStyle(color: Colors.red[900]),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 5.0),
                            Expanded(child: Text(notification.title)),
                            InkWell(
                              focusColor: Colors.grey[100],
                              onTap: () async {
                                if (notification != null)
                                  _navigateToVideoPlayerByData(notification);
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Text(
                                  'OK',
                                  style: TextStyle(fontSize: 10.0),
                                ),
                              ),
                            ),
                            SizedBox(width: 5.0),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
