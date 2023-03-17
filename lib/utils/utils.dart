// ignore_for_file: must_be_immutable, camel_case_types

import 'dart:convert';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:profile_listing/screen/home_page.dart';
import 'package:profile_listing/ui/utils/utils.dart';

void serialiseJson(
    Response response, BuildContext context, Function successFunction) {
  dynamic responseJson = "";

  if (response.statusCode == 200) {
    responseJson = json.decode(response.body);
    print(responseJson);

    successFunction();
  } else if (response.statusCode == 401) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                attendance: [],
              )),
      (Route<dynamic> route) => false,
    );
  } else {
    print(response.statusCode);
    responseJson = json.decode(response.body);

    showMessage(context,
        message: responseJson["message"],
        error: responseJson["data"]["error"],
        isSuccess: false);
  }
}

void showMessage(BuildContext context,
    {String message = "", String error = "", bool isSuccess = false}) {
  Flushbar(
    // title: "Hey Ninja",
    titleColor: Colors.white,
    // message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.easeInOut,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    duration: Duration(seconds: 2),
    messageText: Container(
      // height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: Offset(0, 1),
              spreadRadius: 0.0)
        ],
      ),
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: isSuccess ? Colors.green : Colors.red,
                size: 35,
              ),
              Expanded(
                  child: Padding(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSuccess ? "Success" : (message),
                      style: myTextStyle(16, theme_black, sb),
                      textAlign: TextAlign.start,
                    ),
                    Padding(
                      child: Text(
                        error,
                        style:
                            myTextStyle(14, theme_black.withOpacity(0.5), sb),
                        textAlign: TextAlign.start,
                      ),
                      padding: EdgeInsets.only(top: 2),
                    )
                  ],
                ),
                padding: EdgeInsets.only(left: 10),
              ))
            ],
          )),
    ),
  ).show(context);
}

class LoadingScreen extends StatelessWidget {
  String message;

  LoadingScreen({this.message = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              height: windowSize(context).height(),
              alignment: Alignment.center,
              color: Colors.white.withOpacity(0.5),
              child: BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                          //   valueColor: ,
                          // lineWidth: 3,
                          // color: getColorFromHex(PodGreen),
                          ),
                      Padding(
                        child: Text(
                          '',
                        ),
                        padding: EdgeInsets.only(top: 10),
                      )
                    ],
                  )),
            )));
  }
}

class windowSize {
  var context;

  windowSize(this.context);

  double width() {
    return MediaQuery.of(context).size.width;
  }

  double height() {
    return MediaQuery.of(context).size.height;
  }
}
