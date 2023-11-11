import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac/general/theme/color_theme.dart';

class TTTextTheme {
  static final strikingColorfulTitle = GoogleFonts.bebasNeue(
    fontSize: 36,
    color: TTColorTheme.onBackground,
    fontWeight: FontWeight.w400,
  );

  static final strikingTitle = GoogleFonts.bebasNeue(
    fontSize: 36,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  static final colorfulTitle = GoogleFonts.montserrat(
    color: TTColorTheme.onBackground,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 0.06,
  );

  static final expDisplay = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: TTColorTheme.highlight,
  );

  static TextStyle bodyStatisticDisplay(int displayValue) => GoogleFonts.montserrat(
        fontSize: displayValue < 10
            ? 48
            : displayValue < 100
                ? 40
                : 32,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static final strokeBody = GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.black);

  static final bodyExtraLarge = GoogleFonts.montserrat(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static final bodyLargeBold = GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final bodyLargeSemiBold = GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontStyle: FontStyle.normal,
    letterSpacing: -0.2,
    height: 1,
  );

  static final bodyLarge = GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  static final bodyMediumSemiBold = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static final bodyMedium = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

class StrokeText {
  StrokeText({required this.text, this.body}) {
    body = Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Text(
            text,
            style: TTTextTheme.strokeBody,
          ),
          Text(
            text,
            style: TTTextTheme.bodyLargeBold,
          )
        ],
      ),
    );
  }
  final String text;
  Widget? body;
}
