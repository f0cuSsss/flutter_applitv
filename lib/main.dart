import 'dart:io';
import 'dart:isolate';

import 'package:Applitv/redux/Applistore.dart';
import 'package:Applitv/redux/action.dart';
import 'package:Applitv/services/IsolateService.dart';
import 'package:Applitv/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Applitv/screens/HomeScreen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:Applitv/models/Notification.dart' as Model;

import 'package:move_to_background/move_to_background.dart';

void checkNotification(SendPort sendPort) async {
  while (true) {
    await NotificationService.getNotification().then((notification) {
      print('notification title' + notification.title);
      if (!notification.isEmpty) {
        print('Not null');
        sendPort.send(notification);
      }
    });
    sleep(Duration(seconds: 4));
  }
}

void main() async {
  runApp(
    Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StoreProvider<Model.Notification>(
          store: Applistore().store,
          child: HomeScreen(),
        ),
      ),
    ),
  );

  MoveToBackground.moveTaskToBack();

  await Isolate.spawn(
    checkNotification,
    IsolateService.getInstance().sendPort,
  );

  IsolateService.getInstance().listen((message) {
    Applistore().store.dispatch(SetNotificationAction(notification: message));
  });
}
