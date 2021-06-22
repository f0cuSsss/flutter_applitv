import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:Applitv/models/Notification.dart' as Model;
import 'package:Applitv/screens/NoInternetScreen.dart';
import 'package:Applitv/screens/VideoPlayerScreen.dart';
import 'package:Applitv/utils/check_internet_connection.dart';
import 'package:move_to_background/move_to_background.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _topicButtonsDisabled = false;
  final TextEditingController _topicController =
      TextEditingController(text: 'topic');

  void _navigateToVideoPlayerByData(Model.Notification n) {
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          url: n.videoUrl,
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
  void initState() {
    super.initState();
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
    return StoreConnector<Model.Notification, Model.Notification>(
      converter: (store) => store.state,
      builder: (context, notification) {
        if (notification == null || notification.isEmpty) {
          return _renderWaitingForNotification();
        } else {
          return _renderNotification(notification);
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
                'assets/shadow_transparent.png',
                fit: BoxFit.contain,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              )
            : Image.network(
                notification.bgImgUrl,
                fit: BoxFit.fill,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
        Positioned(
          top: 20,
          left: 20,
          child: IconButton(
            icon: Icon(
              Icons.close,
              size: 26,
            ),
            onPressed: () {
              MoveToBackground.moveTaskToBack();
            },
            iconSize: 30,
          ),
        ),
        // Image.asset(
        //   // 'assets/transparent_bg_2.png',
        //   'assets/shadow_transparent.png',
        //   fit: BoxFit.contain,
        //   height: double.infinity,
        //   width: double.infinity,
        //   alignment: Alignment.center,
        // ),
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
                          'Something went wrong!',
                          style: TextStyle(color: Colors.red[900]),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 5.0),
                            Expanded(child: Text(notification.title)),
                            SizedBox(width: 4.0),
                            RawMaterialButton(
                              padding: EdgeInsets.all(0),
                              shape: CircleBorder(),
                              constraints: BoxConstraints(
                                maxWidth: 35,
                                minWidth: 35,
                                maxHeight: 35,
                                minHeight: 35,
                              ),
                              onPressed: () {
                                if (notification != null)
                                  _navigateToVideoPlayerByData(notification);
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                                size: 18,
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
