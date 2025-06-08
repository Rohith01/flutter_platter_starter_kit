import 'package:flutter/material.dart';

void showSnackBar(
    {required BuildContext context,
    required String message,
    required bool showAction,
    String? actionLabel,
    Function? onPressed}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      action: showAction
          ? SnackBarAction(
              label: actionLabel ?? '',
              disabledTextColor: Colors.white,
              textColor: Colors.yellow,
              onPressed: () {
                if (onPressed != null) {
                  onPressed();
                }
              })
          : null,
    ),
  );
}
