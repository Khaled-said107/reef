import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({required String message, required Color color}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16,
  );
}

enum ToastStates { success, error, warning }

Color chooseToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.success:
      return Colors.green;
    case ToastStates.error:
      return Colors.red;
    case ToastStates.warning:
      return Colors.amber;
  }
}
