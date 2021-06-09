import 'package:Applitv/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Applitv/screens/HomeScreen.dart';
import 'package:provider/provider.dart';

void main() {
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
