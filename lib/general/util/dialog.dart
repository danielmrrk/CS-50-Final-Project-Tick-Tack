import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';

void showGetDialog(String title, Widget content, BuildContext context) {
  Get.defaultDialog(
      title: title,
      titleStyle: TTTextTheme.bodyLarge,
      titlePadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      custom: Container(color: Colors.white10),
      content: content,
      backgroundColor: TTColorTheme.background.withOpacity(0.95),
      barrierDismissible: false,
      onWillPop: () => Future.value(false));
}
