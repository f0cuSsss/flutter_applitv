import 'package:Applitv/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Applitv/screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) {
    NotificationService().instantNotification();
    print("bg notify");
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  await Workmanager.registerPeriodicTask(
    "test_workertask",
    "test_workertask",
    frequency: Duration(seconds: 10), // minimum is 15 min
    inputData: {"data1": "value1", "data2": "value2"},
    initialDelay: Duration(seconds: 5),
  );

  // await Workmanager.registerOneOffTask();

  runApp(
    Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
        },
        child: MultiProvider(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          ),
          providers: [
            ChangeNotifierProvider(create: (_) => NotificationService())
          ],
        )),
  );
}
