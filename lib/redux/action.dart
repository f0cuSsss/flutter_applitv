import 'package:Applitv/models/Notification.dart';

enum NotifActions { clear_notification }

class SetNotificationAction {
  Notification notification;
  SetNotificationAction({this.notification});
}
