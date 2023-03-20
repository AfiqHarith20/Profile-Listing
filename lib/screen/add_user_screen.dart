// for File
import 'package:flutter/material.dart';
import 'package:profile_listing/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddUserScreen extends StatefulWidget {
  final Datum addUser;
  const AddUserScreen({
    Key? key,
    required this.addUser,
  }) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  XFile? image;
  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _avatarController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstnameController.text = widget.addUser.firstName;
    _lastnameController.text = widget.addUser.lastName;
    _emailController.text = widget.addUser.email;
    _avatarController.text = widget.addUser.avatar;
  }

  void addUser() async {
    Uri uri = Uri.parse("https://reqres.in/api/users");
    var response = await http.post(uri);
    print(response.statusCode);
    if (response.statusCode == 200) {
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Successfully Add new User!"),
          backgroundColor: Colors.blueAccent,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  // void pickProfilePic() async {
  //   final image = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     maxHeight: 256,
  //     maxWidth: 256,
  //     imageQuality: 90,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New User'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  getImage(ImageSource.gallery);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 80, bottom: 24),
                  height: 120,
                  width: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.tealAccent,
                  ),
                  child: Center(
                      child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 80,
                  )),
                ),
              ),
              TextFormField(
                controller: _firstnameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "First Name can't be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastnameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Last Name can't be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              // TextField(
              //   controller: _checkInController,
              //   decoration: const InputDecoration(
              //     labelText: 'Check In Time',
              //     prefixIcon: Icon(Icons.timer_rounded),
              //   ),
              // ),
              ElevatedButton(
                onPressed: () {
                  addUser();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
