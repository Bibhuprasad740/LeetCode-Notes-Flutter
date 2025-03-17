import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'global/routes.dart';
import 'providers/problem_provider.dart';
import 'providers/section_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  // dotenv load
  await dotenv.load();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => SectionProvider()),
      ChangeNotifierProvider(create: (_) => ProblemProvider()),
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
        initialRoute: '/',
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
