import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myflutter/screens/HomeScreen.dart';

void main() {
  runApp(
    Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    ),
  );
}
