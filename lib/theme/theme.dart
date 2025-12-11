// theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryColor = Color(0xFF6C63FF);
  static final Color secondaryColor = Color(0xFF00BFA6);
  static final Color backgroundColor = Color(0xFFF6F8FA);
  static final Color cardColor = Colors.white;
  static final Color accentColor = Color(0xFFFF6584);

  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
