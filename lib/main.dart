import 'dart:isolate';
import 'dart:math';

import 'package:Applitv/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Applitv/screens/HomeScreen.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'package:android_alarm_manager/android_alarm_manager.dart';

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
  return await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
}

void checkNotification() async {
  print("-------- Checking notifications... [${DateTime.now()}] --------");
  await fetchAlbum().then((value) {
    print(value);
  });
  print('##### Completing the check for notifications #####');
  Bringtoforeground.bringAppToForeground();
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

  await AndroidAlarmManager?.initialize();

  await AndroidAlarmManager.periodic(
    const Duration(milliseconds: 500),
    Random().nextInt(pow(2, 31).toInt()),
    checkNotification,
    exact: true,
    wakeup: true,
  );
}
