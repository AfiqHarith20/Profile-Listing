import 'package:flutter/material.dart';
import 'package:profile_listing/models/user_model.dart';
import 'package:profile_listing/widget/profile_widget.dart';
import 'package:profile_listing/widget/textfield_widget.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  final Datum edit;
  const EditProfilePage({
    super.key,
    required this.edit,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _avatarController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController.text = widget.edit.firstName;
    _lastNameController.text = widget.edit.lastName;
    _emailController.text = widget.edit.email;
    _avatarController.text = widget.edit.avatar;
  }

  void updateUser({required int id}) async {
    Uri uri = Uri.parse("https://reqres.in/api/users/$id");
    var response = await http.put(uri);
    print(response.statusCode);
    if (response.statusCode == 200) {
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Successfully updated the profile!"),
          backgroundColor: Colors.blueAccent,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Editor"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: widget.edit,
              isEdit: true,
              onClicked: () async {
                controller:
                _avatarController;
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'First Name',
              text: widget.edit.firstName,
              onChanged: (name) {
                controller:
                _firstNameController;
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Last Name',
              text: widget.edit.lastName,
              onChanged: (name) {
                controller:
                _lastNameController;
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Email',
              text: widget.edit.email,
              onChanged: (email) {
                controller:
                _emailController;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: () {
                  updateUser(id: widget.edit.id);
                },
                child: Text("Save"))
          ],
        ),
      ),
    );
  }
}
