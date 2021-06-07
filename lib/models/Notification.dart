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
