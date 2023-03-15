import 'package:flutter/material.dart';

class Attendance {
  final String user;
  final String phoneNum;
  final DateTime checkIn;

  const Attendance({
    required this.user,
    required this.phoneNum,
    required this.checkIn,
  });
}
