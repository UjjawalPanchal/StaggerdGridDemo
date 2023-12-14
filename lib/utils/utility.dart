/*
* Created by Ujjawal Panchal on 11/11/22.
*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';

const String collectionName = 'notifications';

class Utility {
  static void printLog(var log) {
    if (kDebugMode) {
      debugPrint('$log');
    }
  }

  static void showToastMessage(context, String message) {
    FToast.toast(
      context,
      duration: 3000,
      msg: message,
      msgStyle: const TextStyle(color: Colors.white),
    );
  }

  static dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
