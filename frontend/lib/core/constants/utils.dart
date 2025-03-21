import 'package:flutter/material.dart';
// TODO remove whatever is not needed here
Color strengthenColor(Color color, double factor) {
  int r = (color.red * factor).clamp(0, 255).toInt();
  int g = (color.green * factor).clamp(0, 255).toInt();
  int b = (color.blue* factor).clamp(0, 255).toInt();

  return Color.fromARGB(color.alpha, r, g, b);
}

List<DateTime> generateWeekDates(int weekOffset) {
  final today = DateTime.now();
  DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  startOfWeek = startOfWeek.add(Duration(days: weekOffset * 7));

  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}

String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2,'0')}${color.green.toRadixString(16).padLeft(2,'0')}${color.blue.toRadixString(16).padLeft(2,'0')}';
}

Color hexToRgb(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}


String formatUrlFromName(String name) {
  // 1. Trim whitespace:
  String trimmedName = name.trim();

  // 2. Replace spaces with underscores:
  String underscoredName = trimmedName.replaceAll(' ', '_');

  // 3. Convert to lowercase:
  String formattedName = underscoredName.toLowerCase();

  return formattedName;
}
