import 'package:flutter/material.dart';

void navigateTo(Widget screen, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: ((context) => screen)),
  );
}
