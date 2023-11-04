import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTTextTheme {
  static final strikingTitle = GoogleFonts.bebasNeue(
    fontSize: 36,
    color: const Color(0xffB552DE),
    fontWeight: FontWeight.w400,
  );

  static final strokeBody = GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.black);

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

  static final bodyExtraLarge = GoogleFonts.montserrat(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static final bodyLarge = GoogleFonts.montserrat(
    fontSize: 20,
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
