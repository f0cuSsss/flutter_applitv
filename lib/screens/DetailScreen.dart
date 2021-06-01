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
        title: Text("Details"),
      ),
      body: Center(
        child: Text('Title of notification is "${_notif.title}"'),
      ),
    );
  }
}
