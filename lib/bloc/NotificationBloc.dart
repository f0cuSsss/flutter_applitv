import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:Applitv/models/Notification.dart' as Model;

abstract class Bloc {
  void dispose();
}

class NotificationBloc extends Bloc {
  Model.Notification _notification = Model.Notification.nullable();

  StreamController<Model.Notification> _notifStreamController =
      StreamController();
  Stream<Model.Notification> get notifStream => _notifStreamController.stream;

  NotificationBloc() {
    _notifStreamController.add(_notification);
  }

  void setNotification(Model.Notification notif) {
    _notification = notif;
    _notifStreamController.sink.add(_notification);
    print("[setNotification] title: ${_notification.title}");
  }

  void clearNotification() {
    _notification = Model.Notification.nullable();
    _notifStreamController.sink.add(_notification);
  }

  @override
  void dispose() {
    _notifStreamController.close();
  }
}

// class NotificationBloc {
//   Model.Notification _notif;

//   final _stream = BehaviorSubject<Model.Notification>.seeded(null);
//   StreamController _actionController = StreamController();

//   StreamSink get pushNotification => _actionController.sink;
//   Stream get notification => _stream.stream;
//   // Stream get notification => _stream.stream;
//   Sink get _addValue => _stream.sink;

//   NotificationBloc() {
//     // _notif = null;
//     _actionController.stream.listen(_setNotification);
//   }

//   void _setNotification(data) {
//     print('-------------------set notification-----------------');
//     _notif = Model.Notification.getTestData();
//     print(_notif?.title);
//     _addValue.add(_notif);
//   }

//   void modifyNotification(data, bool type) {
//     switch (type) {
//       case true:
//         {
//           _notif = Model.Notification.getTestData();
//           _addValue.add(_notif);
//           break;
//         }
//       case false:
//         {
//           _notif = null;
//           _addValue.add(null);
//           break;
//         }
//       default:
//         break;
//     }
//   }

//   void _clearNotification() {
//     _notif = null;
//     _addValue.add(null);
//   }

//   void dispose() {
//     _stream.close();
//     _actionController.close();
//   }
// }
