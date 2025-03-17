import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Import for platform theme detection

import '../theme/dark_theme.dart';
import '../theme/light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;
  late bool _isDarkMode;

  ThemeProvider() {
    // Check system theme
    final Brightness systemBrightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;

    _isDarkMode = systemBrightness == Brightness.dark;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
  }

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }
}
