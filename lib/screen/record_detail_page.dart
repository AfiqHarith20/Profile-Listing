import 'package:flutter/material.dart';
import 'package:profile_listing/models/user_model.dart';
import 'package:share_plus/share_plus.dart';

class RecordDetailsPage extends StatefulWidget {
  final GetUserModel user;
  const RecordDetailsPage({
    super.key,
    required this.user,
  });

  @override
  State<RecordDetailsPage> createState() => _RecordDetailsPageState();
}

class _RecordDetailsPageState extends State<RecordDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final String contactInfo =
                  "First Name: ${widget.user.first_name}" +
                      " ${widget.user.last_name}\nEmail: ${widget.user.email}";
              Share.share(contactInfo, subject: "user Record");
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
                  subtitle: Text(widget.user.first_name),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_android_rounded),
                  title: const Text("Phone Number"),
                  subtitle: Text(widget.user.last_name),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_android_rounded),
                  title: const Text("Phone Number"),
                  subtitle: Text(widget.user.email),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
