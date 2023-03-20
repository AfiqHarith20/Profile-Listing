import 'package:flutter/material.dart';

enum DialogsAction { yes, no }

class AlertDialogs {
  static Future<DialogsAction> yesCancelDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.no),
              child: Text(
                "No",
                style: TextStyle(
                  color: Color.fromARGB(255, 6, 161, 125),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.yes),
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Color(0xFFC41A3B),
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        );
      },
    );
    return (action != null) ? action : DialogsAction.no;
  }
}
