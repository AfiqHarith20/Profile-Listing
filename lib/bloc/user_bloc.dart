import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:profile_listing/api/constant.dart';
import 'package:profile_listing/main.dart';
import 'package:profile_listing/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum User_Event { GET_USER_FETCH }

class UserBloc {
  BuildContext? context;
  final eventStreamController = new StreamController<User_Event>();

  StreamSink get eventSink => eventStreamController.sink;
  Stream get _eventStream => eventStreamController.stream;

  final stateStreamController = new StreamController<List<GetUserModel>>();

  StreamSink<List<GetUserModel>> get _stateSink => stateStreamController.sink;
  Stream<List<GetUserModel>> get stateStream => stateStreamController.stream;

  UserBloc() {
    dynamic responseJson = "";
    _eventStream.listen((event) async {
      if (event == User_Event.GET_USER_FETCH) {
        var params = HashMap<String, String>();

        Response response = await Constant().initGet(userListing, params);
        if (response.statusCode == 200) {
          print("Awesome ${jsonDecode(response.body)["data"]}");
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          MyApp();
        }

        List responseData = json.decode(response.body)['data'] as List;
        _stateSink
            .add(responseData.map((e) => GetUserModel.fromJson(e)).toList());

        print('user details ${responseData.length}');
      }
    });
  }

  void dispose() {}
}
