import 'dart:convert';

class Notification {
  String title = '';
  String bgImgUrl = '';
  String notifImgUrl = '';
  String videoUrl = '';
  String timeLeft = '';

  Notification({
    this.title,
    this.bgImgUrl,
    this.notifImgUrl,
    this.videoUrl,
    this.timeLeft,
  });

  Notification.nullable() {
    this.title = '';
    this.bgImgUrl = '';
    this.notifImgUrl = '';
    this.videoUrl = '';
    this.timeLeft = '';
  }

  bool get isTitleEmpty => title == '';
  bool get isBgImgUrlEmpty => bgImgUrl == '';
  bool get isNotifImgUrlEmpty => notifImgUrl == '';
  bool get isVideoUrlEmpty => videoUrl == '';

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
      timeLeft: '10',
    );
  }

  factory Notification.fromJson(String str) =>
      Notification.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Notification.fromMap(Map<String, dynamic> json) => Notification(
        title: json["title"],
        bgImgUrl: json["bg_img_url"],
        notifImgUrl: json["notif_img_url"],
        videoUrl: json["video_url"],
        timeLeft: json["time_left"],
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "bg_img_url": bgImgUrl,
        "notif_img_url": notifImgUrl,
        "video_url": videoUrl,
        "time_left": timeLeft,
      };
}
