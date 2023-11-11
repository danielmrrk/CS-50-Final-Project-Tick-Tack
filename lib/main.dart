import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:tic_tac/database/statistic/statistic_database.dart';
import 'package:tic_tac/general/theme/color_theme.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/main_sceen/main_screen.dart';
import 'package:tic_tac/service/model_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  StatisticDatabase.instance.database; // ensures that database was created
  TicTacToeModelService.loadQValues();
  runApp(const ProviderScope(child: TicTacApp()));
}

class TicTacApp extends StatelessWidget {
  const TicTacApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const MainScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff271045),
        filledButtonTheme: const FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color(0xffb552de)),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: TTTextTheme.bodyMedium,
          backgroundColor: TTColorTheme.onBackground,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: TTColorTheme.background,
          elevation: 0,
          titleTextStyle: TTTextTheme.bodyLarge,
        ),
      ),
    );
  }
}
