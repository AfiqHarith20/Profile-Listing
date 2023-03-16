import 'package:flutter/material.dart';
import 'package:profile_listing/models/user_model.dart';

class AddAttandanceRecordScreen extends StatefulWidget {
  final GetUserModel user;
  final void Function(GetUserModel) onSave;
  const AddAttandanceRecordScreen({
    Key? key,
    required this.user,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AddAttandanceRecordScreen> createState() =>
      _AddAttandanceRecordScreenState();
}

class _AddAttandanceRecordScreenState extends State<AddAttandanceRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _avatarController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = widget.user.email;
    _firstnameController.text = widget.user.first_name;
    _lastnameController.text = widget.user.last_name;
    _avatarController.value = widget.user.avatar as TextEditingValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New User Record'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "email can't be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstnameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.phone_android_outlined),
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
                  prefixIcon: Icon(Icons.phone_android_outlined),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Last Name can't be empty";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newuser = GetUserModel(
                      email: _emailController.text,
                      first_name: _firstnameController.text,
                      last_name: _lastnameController.text,
                      avatar: _avatarController.text,
                      id: '' as int,
                    );
                    widget.onSave(newuser);
                  }
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
