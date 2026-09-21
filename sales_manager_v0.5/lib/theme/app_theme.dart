import 'package:flutter/material.dart';

class AppTheme {
  // Solid warm, neutral background (no gradient) — matches the CoStar-style theme.
  static const bg = Color(0xFFC7BFAF);
  static const panel = Color(0xFFF8F4EC);
  static const panel2 = Color(0xFFEFE8D9);
  static const primary = Color(0xFFDDA83B);
  static const accent = Color(0xFFB68A2E);
  static const text = Color(0xFF2B2620);
  static const muted = Color(0xFF7C7566);

  static const shadowColor = Color(0x1A2B2620);

  static BoxDecoration card({double radius = 22}) => BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      );

  static ThemeData dark() => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: bg,
    fontFamily: 'Arial',
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: accent,
      surface: panel,
      onSurface: text,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: text),
      bodyMedium: TextStyle(color: text),
      titleLarge: TextStyle(color: text),
      titleMedium: TextStyle(color: text),
    ),
    iconTheme: const IconThemeData(color: text),
    cardTheme: CardThemeData(
      color: panel,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: panel2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: muted),
    ),
  );
}
