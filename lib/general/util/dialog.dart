import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tic_tac/general/theme/button_theme.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/main_sceen/main_screen.dart';
import 'package:tic_tac/statistic/statistic_screen.dart';

class CustomDialog {
  static Widget buildGameDialogContent({
    required String firstButtonTitle,
    required VoidCallback firstButtonOnTap,
    required String secondButtonTitle,
    required VoidCallback secondButtonOnTap,
  }) =>
      Container(
        width: 272,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
        child: Column(
          children: [
            TTButton(title: firstButtonTitle).fullWidthButton(firstButtonOnTap),
            const SizedBox(height: 8),
            TTButton(title: secondButtonTitle).fullWidthButton(secondButtonOnTap)
          ],
        ),
      );

  static Widget buildRestartGameDialogContent() => Container(
        width: 272,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
        child: Column(
          children: [
            const TTButton(title: "New Game").fullWidthButton(() {
              Get.to(
                () => const MainScreen(
                  reset: true,
                ),
              );
            }),
            const SizedBox(height: 8),
            const TTButton(title: "Statistics").fullWidthButton(() {
              Get.to(
                () => const StatisticScreen(),
              );
            })
          ],
        ),
      );

  static void showGetDialog({required String title, required Widget content, bool closeable = false}) {
    Get.defaultDialog(
        title: title,
        titleStyle: TTTextTheme.bodyLarge,
        titlePadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        custom: Container(color: Colors.white10),
        content: content,
        backgroundColor: TTColorTheme.background.withOpacity(0.95),
        barrierDismissible: closeable,
        onWillPop: () => Future.value(closeable));
  }
}
