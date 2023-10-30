import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTButtonStyle {
  static final fullWidthButtonStyle = ButtonStyle(
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

class TTButton {
  const TTButton({required this.title});
  final String title;

  Widget get fullWidthButton => SizedBox(
        height: 56,
        width: double.infinity,
        child: FilledButton(
          onPressed: () {},
          style: TTButtonStyle.fullWidthButtonStyle,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
}
