import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:profile_listing/api/constant.dart';
import 'package:profile_listing/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class UserScopedModel extends Model {
  List<UserModel> _userList = [];
  List<UserModel> get userList => _userList;
  bool _isLoading = false;
  late int _id;
  late String _email, _first_name, _last_name, _avatar;
  bool get isLoading => _isLoading;
  int totUser = 0;

  void addNewUser(UserModel user) {
    _userList.add(user);
  }

  int getId() {
    return _id;
  }

  int getuserCount() {
    return _userList.length;
  }

  String getEmail() {
    return _email;
  }

  String getFirstName() {
    return _first_name;
  }

  String getLastName() {
    return _last_name;
  }

  String getAvatar() {
    return _avatar;
  }

  Future<dynamic> _getProfileJson() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
      Uri.parse(Constants.basedUrl + 'users/2'),
      headers: {'Content-Type': 'application/json'},
    ).catchError((error) {
      print(error.toString());
      return false;
    });
    print("USER LIST >>>>>>>");
    print(response.statusCode.toString());
    return json.decode(response.body);
  }

  Future fetchProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _isLoading = true;
    notifyListeners();

    var dataFromResponse = await _getProfileJson();
    print('USER INFO DATA ************************************************');
    print(dataFromResponse);

    _id = dataFromResponse['data']['user']['id'];
    _first_name = dataFromResponse['data']['user']['first_name'];
    _last_name = dataFromResponse['data']['user']['last_name'];
    _email = dataFromResponse['data']['user']['email'];
    _avatar = dataFromResponse['data']['user']['avatar'];

    prefs.setInt('id', _id);
    _isLoading = false;
    notifyListeners();
  }

  Future parseUserFromRespond(int id, int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (page == 1) {
      _isLoading = true;
    }
    var dataFromResponse = await _getProfileJson();
    notifyListeners();

    totUser = dataFromResponse['data']['user']['total'];
  }
}
