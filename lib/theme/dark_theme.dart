import 'package:flutter/material.dart';
import '../global/constants.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: "Metropolis",
  useMaterial3: true,

  // Background colors
  scaffoldBackgroundColor: AppColors.darkBackground,

  // Text theme
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.darkPrimaryFont,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(color: AppColors.darkPrimaryFont, fontSize: 18),
    bodySmall: TextStyle(color: AppColors.darkSecondaryFont, fontSize: 12),
    labelLarge: TextStyle(
        color: AppColors.darkPrimaryFont, fontWeight: FontWeight.w500),
    titleLarge: TextStyle(
        color: AppColors.darkPrimaryFont,
        fontWeight: FontWeight.w600,
        fontSize: 20),
    titleMedium: TextStyle(
        color: AppColors.darkPrimaryFont,
        fontWeight: FontWeight.w500,
        fontSize: 16),
    headlineMedium: TextStyle(
        color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 24),
  ),

  // Color scheme
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkPrimaryFont,
    background: AppColors.darkBackground,
    onBackground: AppColors.darkPrimaryFont,
    error: AppColors.error,
    onError: Colors.white,
  ),

  // Input decoration
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkTextField,
    hintStyle: const TextStyle(color: AppColors.darkPlaceholder),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 20,
    ),
  ),

  // Card theme - important for food items
  cardTheme: CardTheme(
    color: AppColors.darkCard,
    elevation: 1,
    shadowColor: AppColors.darkShadow,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
  ),

  // Divider theme
  dividerTheme: const DividerThemeData(
    color: AppColors.darkDivider,
    thickness: 1,
    space: 24,
  ),

  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.primary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      fontFamily: "Metropolis",
    ),
    iconTheme: IconThemeData(color: AppColors.primary),
  ),

  // Button themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      elevation: 3,
    ),
  ),

  // Floating action button - for cart/checkout
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 4,
    shape: CircleBorder(),
  ),

  // Bottom navigation - for app sections
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.darkSecondaryFont,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
);
