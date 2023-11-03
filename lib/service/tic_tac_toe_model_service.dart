import 'dart:convert';

import 'package:flutter/services.dart';

class TicTacToeModelService {
  static late final Map<String, dynamic>? qValuesMap;
  static Future<void> loadQValues() async {
    qValuesMap = json.decode(await rootBundle.loadString("assets/q_values.json"));
  }
}
