import 'package:profile_listing/models/attendance.dart';
import 'package:flutter/material.dart';

class AddAttandanceRecordScreen extends StatefulWidget {
  final Attendance attendance;
  final void Function(Attendance) onSave;
  const AddAttandanceRecordScreen({
    Key? key,
    required this.attendance,
    required this.onSave,
  }) : super(key: key);

  @override
  State<AddAttandanceRecordScreen> createState() =>
      _AddAttandanceRecordScreenState();
}

class _AddAttandanceRecordScreenState extends State<AddAttandanceRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _checkInController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.attendance.user;
    _phoneNumberController.text = widget.attendance.phoneNum;
    _checkInController.text = widget.attendance.checkIn.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Attendance Record'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Name can't be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_android_outlined),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Phone Number can't be empty";
                  }
                  return null;
                },
              ),
              TextField(
                controller: _checkInController,
                decoration: const InputDecoration(
                  labelText: 'Check In Time',
                  prefixIcon: Icon(Icons.timer_rounded),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newAttendance = Attendance(
                      user: _nameController.text,
                      phoneNum: _phoneNumberController.text,
                      checkIn: DateTime.parse(_checkInController.text),
                    );
                    widget.onSave(newAttendance);
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
