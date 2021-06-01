import 'package:flutter/material.dart';
import 'package:myflutter/models/NotificationItem.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen(this.notification);
  final NotificationItem notification;
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  NotificationItem _notif;

  @override
  void initState() {
    super.initState();
    _notif = widget.notification;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_notif.title),
      ),
      body: Center(
        child: Column(
          children: [
            InkWell(
              child: Text(_notif.videoUrl == null
                  ? 'Something went wrong'
                  : _notif.videoUrl),
              onTap: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
