import 'package:Applitv/redux/action.dart';
import 'package:Applitv/models/Notification.dart';
import 'package:bringtoforeground/bringtoforeground.dart';

Notification NotifReducer(Notification state, dynamic action) {
  if (action is SetNotificationAction) {
    var notif = (action as SetNotificationAction).notification;
    if (!state.isEqual(notif)) {
      state = notif;
      Bringtoforeground.bringAppToForeground();
    }
    return state;
  }

  if (action == NotifActions.clear_notification) {
    state = Notification.nullable();
    return state;
  }

  return state;
}
