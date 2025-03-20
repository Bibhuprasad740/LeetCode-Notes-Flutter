import 'package:flutter/material.dart';

class AppColors {
  // Common Colors
  static const Color primary = Color.fromARGB(255, 42, 58, 146); // Dark orange
  static const Color secondary =
      Color.fromARGB(255, 179, 120, 24); // Green (complementary to orange)
  static const Color error = Color(0xFFE53935); // Clear red
  static const Color warning = Color(0xFFFFA000); // Amber
  static const Color info = Color(0xFF2196F3); // Blue

  // Light Theme Colors
  static const Color lightPrimaryFont = Color(0xFF212121); // Nearly black
  static const Color lightSecondaryFont = Color(0xFF757575); // Medium gray
  static const Color lightPlaceholder = Color(0xFFBDBDBD); // Light gray
  static const Color lightTextField =
      Color.fromARGB(255, 234, 234, 234); // Off-white
  static const Color lightBackground =
      Color.fromARGB(255, 240, 240, 240); // White
  static const Color lightSurface = Colors.white; // white
  static const Color lightCard = Colors.white; // White
  static const Color lightDivider = Color(0xFFEEEEEE); // Light gray divider
  static const Color lightShadow = Color(0x14000000); // Light shadow

  // Dark Theme Colors
  static const Color darkPrimaryFont = Color(0xFFEEEEEE); // Off-white
  static const Color darkSecondaryFont = Color(0xFFB0B0B0); // Light gray
  static const Color darkPlaceholder = Color(0xFF616161); // Dark gray
  static const Color darkTextField =
      Color.fromARGB(255, 56, 56, 56); // Very dark gray
  static const Color darkBackground = Color(0xFF1E1E1E); // Dark gray
  static const Color darkSurface = Color(0xFF121212); // Nearly black
  static const Color darkCard = Color.fromARGB(255, 20, 20, 20); // Dark gray
  static const Color darkDivider = Color(0xFF383838); // Medium-dark gray
  static const Color darkShadow = Color(0x40000000); // Dark shadow

  // Food-related accent colors (same for both themes)
  static const Color success = Color(0xFF4CAF50); // Green - for success states
  static const Color accent1 =
      Color(0xFFE91E63); // Pink - for desserts/specials
  static const Color accent2 =
      Color(0xFFFFC107); // Yellow - for promotions/offers
  static const Color primaryLight =
      Color(0xFFFFCCBC); // Light orange - for highlights
  static const Color primaryDark =
      Color(0xFFD84315); // Deep orange - for important actions
}
