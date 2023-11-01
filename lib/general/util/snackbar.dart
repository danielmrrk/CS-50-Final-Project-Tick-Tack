import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message, int seconds) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(milliseconds: seconds),
  ));
}
