import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


// Show a flutter toast 
void showToast(String? message) {
  Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.shade100,
      textColor: Colors.black.withOpacity(0.9),
      fontSize: 16.0);
}
