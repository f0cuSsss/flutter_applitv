import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:Applitv/redux/reducer.dart';
import 'package:Applitv/models/Notification.dart';

class Applistore {
  static final Applistore _singleton = Applistore._internal();
  Store store = Store<Notification>(
    NotifReducer,
    initialState: Notification.nullable(),
  );
  factory Applistore() {
    return _singleton;
  }

  Applistore._internal();
}
