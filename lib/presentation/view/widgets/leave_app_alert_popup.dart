import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platter/core/constants.dart';

Future<void> showLeaveAppPopup(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('You are about to leave the app'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('There is more to explore in this app, when you login.'),
              Text('Would you like to stay and explore the app?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes', style: TextStyle(color: kPrimaryText)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('No', style: TextStyle(color: kPrimaryText)),
            onPressed: () {
              Navigator.of(context).pop();
              SystemNavigator.pop();
            },
          ),
        ],
      );
    },
  );
}
