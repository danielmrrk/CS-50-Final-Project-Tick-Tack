import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';

void showSimpleGetSnackbar(String message, int seconds) {
  Get.closeCurrentSnackbar();
  Get.rawSnackbar(
    messageText: Text(
      message,
      style: TTTextTheme.bodyMedium,
    ),
    backgroundColor: TTColorTheme.onBackground,
    borderRadius: 8,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
    duration: Duration(seconds: seconds),
  );
}
