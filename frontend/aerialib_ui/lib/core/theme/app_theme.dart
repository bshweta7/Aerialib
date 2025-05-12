// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

ThemeData getAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFB39DDB),
      background: const Color(0xFFFFFDF8),
    ).copyWith(
      primary: const Color(0xFFB39DDB),
      secondary: const Color(0xFF80CBC4),
    ),
    scaffoldBackgroundColor: const Color(0xFFE4E2ED),
    fontFamily: "Cera Pro",
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF3A2E58),
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE3DFF5),
        foregroundColor: const Color(0xFF3A2E58),
        shadowColor: Colors.black12,
        elevation: 1,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xFF3A2E58),
            width: 2,
          ),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
          color: Color(0xFF3A2E58),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xFFB39DDB),
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    searchBarTheme: SearchBarThemeData(
      backgroundColor: MaterialStateProperty.all(const Color(0xFFF5F3FB)),
      hintStyle: MaterialStateProperty.all(
        TextStyle(color: Colors.grey[600]),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(color: Color(0xFF3A2E58)),
      ),
    ),
  );
}
