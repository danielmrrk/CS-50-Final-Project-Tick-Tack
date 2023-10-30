import 'package:flutter/material.dart';
import 'package:tic_tac/main_sceen/main_screen.dart';

const ColorScheme kColorScheme = ColorScheme.dark(background: Color(0xff271045), onBackground: Color(0xff271045));

void main() {
  runApp(const TicTacApp());
}

class TicTacApp extends StatelessWidget {
  const TicTacApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
      theme: ThemeData(colorScheme: kColorScheme),
    );
  }
}
