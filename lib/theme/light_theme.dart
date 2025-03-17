import 'package:flutter/material.dart';
import '../global/constants.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: "Metropolis",
  useMaterial3: true,

  // Background colors
  scaffoldBackgroundColor: AppColors.lightBackground,

  // Text theme
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.lightPrimaryFont,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(color: AppColors.lightPrimaryFont, fontSize: 18),
    bodySmall: TextStyle(color: AppColors.lightSecondaryFont, fontSize: 12),
    labelLarge: TextStyle(
        color: AppColors.lightPrimaryFont, fontWeight: FontWeight.w500),
    titleLarge: TextStyle(
        color: AppColors.lightPrimaryFont,
        fontWeight: FontWeight.w600,
        fontSize: 20),
    titleMedium: TextStyle(
        color: AppColors.lightPrimaryFont,
        fontWeight: FontWeight.w500,
        fontSize: 16),
    headlineMedium: TextStyle(
        color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 24),
  ),

  // Color scheme
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightPrimaryFont,
    background: AppColors.lightBackground,
    onBackground: AppColors.lightPrimaryFont,
    error: AppColors.error,
    onError: Colors.white,
  ),

  // Input decoration
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightTextField,
    hintStyle: TextStyle(color: AppColors.lightPlaceholder, fontSize: 14),
    isDense: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.primary,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.primary,
      ),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),

  // Card theme - important for food items
  cardTheme: CardTheme(
    color: AppColors.lightCard,
    elevation: 2,
    shadowColor: AppColors.lightShadow,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
  ),

  // Divider theme
  dividerTheme: const DividerThemeData(
    color: AppColors.lightDivider,
    thickness: 1,
    space: 24,
  ),

  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightSurface,
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
    backgroundColor: AppColors.lightBackground,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.lightSecondaryFont,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
);
