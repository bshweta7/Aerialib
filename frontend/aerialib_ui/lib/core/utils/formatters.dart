// Useful functions

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String formatUrlFromName(String name) {
  // 1. Trim whitespace:
  String trimmedName = name.trim();

  // 2. Replace spaces with underscores:
  String underscoredName = trimmedName.replaceAll(' ', '_');

  // 3. Convert to lowercase:
  String formattedName = underscoredName.toLowerCase();

  return formattedName;
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() +
      text.substring(1);
}

String formatNameFromPath(String path) {
  // Replace - with spaces:
  String formattedName = path.replaceAll('-', ' ');

  return capitalizeFirstLetter(formattedName);
}
