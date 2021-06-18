import 'dart:isolate';

import 'package:flutter/material.dart';

class IsolateService {
  @protected
  static ReceivePort _port;

  IsolateService._internal();

  static ReceivePort getInstance() {
    if (_port == null) _port = new ReceivePort();
    return _port;
  }
}
