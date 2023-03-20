import 'package:flutter/material.dart';
import 'package:profile_listing/models/user_model.dart';
import 'package:profile_listing/screen/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.profile});
  final Datum profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${profile.firstName} Profile"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      edit: profile,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.mode_edit,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.tealAccent,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(profile.avatar),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  profile.firstName + " " + profile.lastName,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                Icon(
                  Icons.email,
                  size: 40,
                ),
                const SizedBox(height: 10),
                Text(
                  profile.email,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Send Email",
                    textScaleFactor: 1.5,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    shape: StadiumBorder(),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
