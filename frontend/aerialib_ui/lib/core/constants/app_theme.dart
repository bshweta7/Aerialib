// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

const appTextTheme = TextTheme(
  headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  bodyLarge: TextStyle(fontSize: 16),
  bodyMedium: TextStyle(fontSize: 14),
  labelSmall: TextStyle(fontSize: 12, color: Colors.grey),
);

ThemeData getLightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFB39DDB), // Lavender
      background: const Color(0xFFFFFDF8), // Soft off-white background
    ).copyWith(
      primary: const Color(0xFFB39DDB), // Lavender
      secondary: const Color(0xFF80CBC4), // Muted Teal
    ),
    textTheme: appTextTheme,
    scaffoldBackgroundColor: const Color(0xFFE4E2ED),
    fontFamily: "Cera Pro",
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: const Color(0xFF3A2E58), // plum text // TODO use theme colors constants file
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE3DFF5),
        // softer lavender backgroundColor: const Color(0xFFB39DDB), // lavender
        foregroundColor: const Color(0xFF3A2E58),
        // plum text
        shadowColor: Colors.black12,
        elevation: 1,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: const Color(0xFF3A2E58),
            // plum text color: Color(0xFF80CBC4), // muted teal border
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
      // light lavender
      // surfaceTintColor: Colors.transparent, // removes default Material3 overlay tint
      // shadowColor: Colors.transparent,
      hintStyle: MaterialStateProperty.all(
        TextStyle(color: Colors.grey[600]),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(color: Color(0xFF3A2E58)), // deep plum text
      ),
      // shape: MaterialStateProperty.all(
      //   RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30),
      //     side: const BorderSide(color: Color(0xFFB39DDB), width: 1.5),
      //   ),
      // ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFF5F3FB), // soft lavender background
      selectedItemColor: Color(0xFF3A2E58), // deep plum for selected item
      unselectedItemColor: Color(0xFFB39DDB), // lavender for unselected
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),


  );
  // TODO add dark mode. reference: https://api.flutter.dev/flutter/material/SearchBar-class.html
}

ThemeData getDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    textTheme: appTextTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF9575CD), // Dark lavender
      brightness: Brightness.dark,
    ),
    fontFamily: "Cera Pro",
    scaffoldBackgroundColor: const Color(0xFF1E1B2E),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Color(0xFF2A2140),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF61518F),
        foregroundColor: Colors.white,
        elevation: 1,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.white38, width: 1),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: const Color(0xFF2E2B3A),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade700, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF9575CD), width: 2.5),
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2A2140),
      selectedItemColor: Colors.white,
      unselectedItemColor: Color(0xFFB39DDB),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
    ),

  );
}

