import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:leetcode_notes/theme/dark_theme.dart';
import 'package:leetcode_notes/theme/light_theme.dart';
import 'package:provider/provider.dart';

import 'global/routes.dart';
import 'providers/auth_provider.dart';
import 'providers/problem_provider.dart';
import 'providers/section_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  // dotenv load
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => SectionProvider()),
      ChangeNotifierProvider(create: (_) => ProblemProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => MaterialApp(
        title: 'LeetCode Notes',
        debugShowCheckedModeBanner: false,
        theme: themeProvider.currentTheme,
        // theme: lightTheme,
        // theme: darkTheme,
        initialRoute: '/',
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
