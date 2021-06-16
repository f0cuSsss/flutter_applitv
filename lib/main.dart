import 'dart:isolate';
import 'dart:math';

import 'package:Applitv/bloc/NotificationBloc.dart';
import 'package:Applitv/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Applitv/screens/HomeScreen.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:Applitv/models/Notification.dart' as Model;

import 'package:http/http.dart' as http;
import 'package:bringtoforeground/bringtoforeground.dart';

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) {
    // NotificationService().instantNotification();
    print("bg notify");
    return Future.value(true);
  });
}

Future<http.Response> fetchAlbum() async {
  return await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );
}

NotificationBloc notifBlock = NotificationBloc();

void checkNotification() async {
  print("-------- Checking notifications... [${DateTime.now()}] --------");

  var test = new Model.Notification(
    title: 'Test title',
    bgImgUrl:
        'https://blog.prezi.com/wp-content/uploads/2019/03/jason-leung-479251-unsplash.jpg',
    notifImgUrl:
        'https://img.freepik.com/free-vector/gradient-liquid-abstract-background_52683-60469.jpg?size=626&ext=jpg',
    videoUrl: 'https://site332.tangram-studio.com/uploads/66/35/20/bee.mp4',
    timeLeft: '10',
  );
  // notifBlock.pushNotification.add(test);
  notifBlock.setNotification(test);

  // Check and bring to froreground if a new notification added
  // Bringtoforeground.bringAppToForeground();
}

void main() async {
  runApp(
    Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        )),
  );

  Model.Notification q = Model.Notification.nullable();
  print(q.isEmpty);

  await AndroidAlarmManager?.initialize();

  await AndroidAlarmManager.periodic(
    const Duration(milliseconds: 500),
    Random().nextInt(pow(2, 31).toInt()),
    checkNotification,
    exact: true,
    wakeup: true,
  );
}
