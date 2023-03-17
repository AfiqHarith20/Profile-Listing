import 'package:flutter/material.dart';
import 'package:profile_listing/models/attendance.dart';
import 'package:profile_listing/models/user_model.dart';
import 'package:profile_listing/scoped/scoped_user.dart';
import 'package:share_plus/share_plus.dart';

class RecordDetailsPage extends StatefulWidget {
  final Attendance attendance;
  const RecordDetailsPage({
    super.key,
    required this.attendance,
  });

  @override
  State<RecordDetailsPage> createState() => _RecordDetailsPageState();
}

class _RecordDetailsPageState extends State<RecordDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Record"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final String contactInfo =
                  "Name: ${widget.attendance.user}\nPhone Number: ${widget.attendance.phoneNum}\nCheck-In Time: ${widget.attendance.checkIn}";
              Share.share(contactInfo, subject: "Attendance Record");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.person_outline_rounded),
                  title: const Text("Name"),
                  subtitle: Text(widget.attendance.user),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_android_rounded),
                  title: const Text("Phone Number"),
                  subtitle: Text(widget.attendance.phoneNum),
                ),
                ListTile(
                  leading: const Icon(Icons.timer_rounded),
                  title: const Text("Check-In Time"),
                  subtitle: Text(widget.attendance.checkIn.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
