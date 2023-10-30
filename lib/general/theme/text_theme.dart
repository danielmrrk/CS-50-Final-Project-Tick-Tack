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

  static final bodyLarge = GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

class StrokeText {
  StrokeText({required this.text, this.body}) {
    body = Stack(
      children: [
        Text(
          text,
          style: TTTextTheme.strokeBody,
        ),
        Text(
          text,
          style: TTTextTheme.bodyLarge,
        )
      ],
    );
  }
  final String text;
  Stack? body;
}
