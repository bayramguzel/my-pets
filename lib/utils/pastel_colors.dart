import 'package:flutter/material.dart';

/// Provides a curated collection of beautiful pastel colors
/// for cards, chips, and UI elements across the application,
/// supporting both light and dark themes.
class PastelColors {
  // Light mode soft pastel background colors
  static const List<Color> lightCardColors = [
    Color(0xFFE8F5E9), // Mint Green
    Color(0xFFF3E5F5), // Lavender Purple
    Color(0xFFE1F5FE), // Sky Blue
    Color(0xFFFFE0B2), // Warm Peach
    Color(0xFFFCE4EC), // Soft Rose
    Color(0xFFFFF9C4), // Lemon Butter
    Color(0xFFE0F2F1), // Soft Seafoam / Aqua
    Color(0xFFEDE7F6), // Periwinkle
    Color(0xFFFFECB3), // Soft Apricot / Amber
    Color(0xFFE3F2FD), // Ice Blue
    Color(0xFFE8EAF6), // Soft Indigo
    Color(0xFFFFE4E1), // Misty Rose
  ];

  // Light mode matching borders (slightly deeper pastel tone)
  static const List<Color> lightBorderColors = [
    Color(0xFFC8E6C9),
    Color(0xFFE1BEE7),
    Color(0xFFB3E5FC),
    Color(0xFFFFCC80),
    Color(0xFFF8BBD0),
    Color(0xFFFFF59D),
    Color(0xFFB2DFDB),
    Color(0xFFD1C4E9),
    Color(0xFFFFE082),
    Color(0xFFBBDEFB),
    Color(0xFFC5CAE9),
    Color(0xFFFFCDD2),
  ];

  // Dark mode pastel-tinted surfaces (maintains legibility and eye comfort)
  static const List<Color> darkCardColors = [
    Color(0xFF1E2E24), // Dark Mint
    Color(0xFF2C223A), // Dark Lavender
    Color(0xFF192A3A), // Dark Sky
    Color(0xFF33261C), // Dark Peach
    Color(0xFF331E27), // Dark Rose
    Color(0xFF2F2C1A), // Dark Lemon
    Color(0xFF192E2B), // Dark Seafoam
    Color(0xFF232238), // Dark Periwinkle
    Color(0xFF33251B), // Dark Apricot
    Color(0xFF1A2736), // Dark Ice
    Color(0xFF202236), // Dark Indigo
    Color(0xFF332024), // Dark Misty Rose
  ];

  // Dark mode pastel borders
  static const List<Color> darkBorderColors = [
    Color(0xFF3D6149),
    Color(0xFF5B3E75),
    Color(0xFF33597D),
    Color(0xFF6B4D36),
    Color(0xFF6B3A4F),
    Color(0xFF635C33),
    Color(0xFF33635C),
    Color(0xFF484575),
    Color(0xFF6B4C33),
    Color(0xFF355577),
    Color(0xFF414777),
    Color(0xFF6B3E48),
  ];

  /// Returns a pastel background color for a given item index.
  static Color getCardColor(int index, {required bool isDark}) {
    final list = isDark ? darkCardColors : lightCardColors;
    return list[index.abs() % list.length];
  }

  /// Returns a matching pastel border color for a given item index.
  static Color getBorderColor(int index, {required bool isDark}) {
    final list = isDark ? darkBorderColors : lightBorderColors;
    return list[index.abs() % list.length];
  }

  // Pre-defined category pastel tones for Settings & Sections
  static Color themeCategoryColor(bool isDark) =>
      isDark ? const Color(0xFF2B223B) : const Color(0xFFF3E5F5);
  static Color themeCategoryBorder(bool isDark) =>
      isDark ? const Color(0xFF5A3E75) : const Color(0xFFE1BEE7);

  static Color generalCategoryColor(bool isDark) =>
      isDark ? const Color(0xFF192A3A) : const Color(0xFFE1F5FE);
  static Color generalCategoryBorder(bool isDark) =>
      isDark ? const Color(0xFF33597D) : const Color(0xFFB3E5FC);

  static Color aboutCategoryColor(bool isDark) =>
      isDark ? const Color(0xFF1E2E24) : const Color(0xFFE8F5E9);
  static Color aboutCategoryBorder(bool isDark) =>
      isDark ? const Color(0xFF3D6149) : const Color(0xFFC8E6C9);

  static Color dataCategoryColor(bool isDark) =>
      isDark ? const Color(0xFF331E27) : const Color(0xFFFCE4EC);
  static Color dataCategoryBorder(bool isDark) =>
      isDark ? const Color(0xFF6B3A4F) : const Color(0xFFF8BBD0);
}

