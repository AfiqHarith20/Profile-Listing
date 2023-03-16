import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String basedUrl = "https://reqres.in/api/";

const String userListing = 'users?page=1';
const String createUser = 'users';
const String editUser = 'user/';
const String deleteUser = 'user/';
const String getSingleUser = 'users/';

class Constant {
  Future<Response> initPostData(
      String endPoint, HashMap<String, String> params) async {
    print('params.toString() $params');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(basedUrl + createUser);

    var response = await post(
      url,
      body: jsonEncode(params),
    );

    return response;
  }

  Future<Response> initPostDeleteData(
    String endpoint,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(basedUrl + deleteUser);
    var response = await delete(
      url,
    );

    return response;
  }

  Future<Response> initGet(String ep, HashMap<String, String> params) async {
    print(params.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(basedUrl + userListing);
    var response = await get(url);

    return response;
  }
}
