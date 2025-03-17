import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/problem_details_screen.dart';
import '../screens/section_details_screen.dart';
import '../screens/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Uri uri = Uri.parse(settings.name!);

  // Handle dynamic routes
  if (uri.pathSegments.length == 2) {
    return _handleDynamicRoutes(uri);
  }

  // Handle static routes using a map
  final routes = <String, WidgetBuilder>{
    '/': (context) => const SplashScreen(),
  };

  WidgetBuilder? builder = routes[settings.name];
  return MaterialPageRoute(
    builder: (context) =>
        builder != null ? builder(context) : const HomeScreen(),
  );
}

Route<dynamic> _handleDynamicRoutes(Uri uri) {
  final String id = uri.pathSegments[1];

  switch (uri.pathSegments[0]) {
    case 'problem':
      return MaterialPageRoute(
        builder: (context) => ProblemDetailsScreen(questionId: id),
      );
    case 'section':
      return MaterialPageRoute(
        builder: (context) => SectionDetailsScreen(sectionId: id),
      );

    default:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
  }
}
