import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:profile_listing/api/constant.dart';
import 'package:profile_listing/bloc/user_bloc.dart';
import 'package:profile_listing/utils/utils.dart';

import '../main.dart';

enum Add_User_Event {
  POST_USER,
  POST_EDIT_USER,
  POST_DELETE_USER,
  GET_USERS_DEFAULT_ADD,
}

class Add_User_Bloc {
  late String id2;
  late BuildContext context;

  final _eventStreamController = StreamController<Add_User_Event>.broadcast();

  StreamSink get eventSink => _eventStreamController.sink;
  Stream get _eventSteam => _eventStreamController.stream;

  final _stateStreamController = StreamController<dynamic>.broadcast();

  StreamSink get _stateSink => _stateStreamController.sink;
  Stream get stateSteam => _stateStreamController.stream;

  HashMap<String, String> params = new HashMap<String, String>();

  void initAddNewUser(
    BuildContext context,
    String email,
    String first_name,
    String last_name,
    String avatar,
    UserBloc userBloc,
  ) {
    this.context = context;
    this._userBloc = userBloc;

    params.clear();
    params.putIfAbsent("email", () => email);
    params.putIfAbsent("first_name", () => first_name);
    params.putIfAbsent("last_name", () => last_name);
    params.putIfAbsent("avatar", () => avatar);

    print('my new confirm $params');

    eventSink.add(Add_User_Event.POST_USER);
  }

  UserBloc? _userBloc;

  void initEditUser(
    BuildContext context,
    String id,
    String email,
    String first_name,
    String last_name,
    String avatar,
    UserBloc userBloc,
  ) {
    this.context = context;
    this.id2 = id;

    params.clear();
    params.putIfAbsent("email", () => email);
    params.putIfAbsent("first_name", () => first_name);
    params.putIfAbsent("last_name", () => last_name);
    params.putIfAbsent("avatar", () => avatar);

    print('my new confirm $params');
    print('my new id $id');

    this._userBloc = _userBloc;

    eventSink.add(Add_User_Event.POST_EDIT_USER);
  }

  void InitDeleteUser(
    BuildContext context,
    String id,
  ) {
    this.context = context;
    this.id2 = id;

    eventSink.add(Add_User_Event.POST_DELETE_USER);
  }

  Function? refreshUser;

  void initGetDefaultUser(BuildContext context, String id, {refreshUser}) {
    this.refreshUser = refreshUser;

    this.context = context;
    this.id2 = id;

    eventSink.add(Add_User_Event.GET_USERS_DEFAULT_ADD);
  }

  Add_User_Bloc() {
    dynamic responseJson = "";
    _eventSteam.listen((event) async {
      if (event == Add_User_Event.POST_USER) {
        _stateSink.add('load');

        Response response = await Constant().initPostData(createUser, params);

        _stateSink.add('finish');

        serialiseJson(response, context, () async {
          _userBloc!.eventSink.add(User_Event.GET_USER_FETCH);
          responseJson = json.decode(response.body);
          print("User post $responseJson");
        });
      } else if (event == Add_User_Event.POST_EDIT_USER) {
        _stateSink.add('load');

        Response response =
            await Constant().initPostData(editUser + '$id2', params);

        _stateSink.add('finish');

        serialiseJson(response, context, () async {
          _userBloc!.eventSink.add(User_Event.GET_USER_FETCH);
          responseJson = json.decode(response.body);
          Navigator.pop(context);

          print("User post $responseJson");
        });
      } else if (event == Add_User_Event.POST_DELETE_USER) {
        _stateSink.add('load');

        Response response = await Constant().initPostDeleteData(
          deleteUser + '$id2',
        );

        _stateSink.add('finish');

        refreshUser!();

        serialiseJson(response, context, () async {
          _userBloc?.eventSink.add(User_Event.GET_USER_FETCH);
          responseJson = json.decode(response.body);
          Navigator.pop(context);
        });
      }
    });
  }
}
