import 'dart:convert';

import 'package:Applitv/utils/config.dart';

class Notification {
  String title = '';
  String bgImgUrl = '';
  String notifImgUrl = '';
  String videoUrl = '';

  Notification({
    this.title,
    this.bgImgUrl,
    this.notifImgUrl,
    this.videoUrl,
  });

  Notification.nullable() {
    this.title = '';
    this.bgImgUrl = '';
    this.notifImgUrl = '';
    this.videoUrl = '';
  }

  bool isEqual(Notification second) {
    return this.title == second.title &&
        this.bgImgUrl == second.bgImgUrl &&
        this.notifImgUrl == second.notifImgUrl &&
        this.videoUrl == second.videoUrl;
  }

  bool get isTitleEmpty => title == '' || title == null;
  bool get isBgImgUrlEmpty => bgImgUrl == '' || bgImgUrl == null;
  bool get isNotifImgUrlEmpty => notifImgUrl == '' || notifImgUrl == null;
  bool get isVideoUrlEmpty => videoUrl == '' || videoUrl == null;

  bool get isEmpty {
    return this.isTitleEmpty &&
        this.isBgImgUrlEmpty &&
        this.isNotifImgUrlEmpty &&
        this.isVideoUrlEmpty;
  }

  static Notification getTestData() {
    return Notification(
      title: 'Test title',
      bgImgUrl:
          'https://blog.prezi.com/wp-content/uploads/2019/03/jason-leung-479251-unsplash.jpg',
      notifImgUrl:
          'https://img.freepik.com/free-vector/gradient-liquid-abstract-background_52683-60469.jpg?size=626&ext=jpg',
      videoUrl: 'https://site332.tangram-studio.com/uploads/66/35/20/bee.mp4',
    );
  }

  factory Notification.fromJson(String str) =>
      Notification.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Notification.fromMap(Map<String, dynamic> json) => Notification(
        title: json["element"]["title"],
        bgImgUrl: Config.URL + json["element"]["bgImgUrl"],
        notifImgUrl: Config.URL + json["element"]["notifImgUrl"],
        videoUrl: json["element"]["videoUrl"],
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "bgImgUrl": bgImgUrl,
        "notifImgUrl": notifImgUrl,
        "videoUrl": videoUrl,
      };
}
