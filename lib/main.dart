import 'package:flutter/material.dart';
import 'package:tic_tac/main_sceen/main_screen.dart';

void main() {
  runApp(const TicTacApp());
}

class TicTacApp extends StatelessWidget {
  const TicTacApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff271045),
        filledButtonTheme: const FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color(0xffb552de)),
          ),
        ),
      ),
    );
  }
}
