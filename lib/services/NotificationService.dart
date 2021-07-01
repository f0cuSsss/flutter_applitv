import 'package:Applitv/models/Notification.dart';
import 'package:Applitv/redux/Applistore.dart';
import 'package:Applitv/redux/action.dart';
import 'package:Applitv/services/HTTPService.dart';
import 'package:Applitv/utils/config.dart';
import 'package:Applitv/utils/reg_array.dart';

class NotificationService {
  static Future<Notification> getNotification() async {
    try {
      // String uri = 'site332.tangram-studio.com';
      String uri = 'applitvmedia.com';
      String endpoint = '/api/element/get';
      return await HTTPService.doGet(Uri.https(Config.authority, endpoint))
          .then((res) {
        if (isArray(res.body)) {
          Applistore().store.dispatch(NotifActions.clear_notification);
          return Notification.nullable();
        }

        if (res.statusCode == 200) {
          final Notification notification = Notification.fromJson(res.body);
          print(notification.title);
          return notification;
        }

        return Notification.nullable();
      });
    } catch (err) {
      print(err);
      return Notification.nullable();
    }
  }
}
