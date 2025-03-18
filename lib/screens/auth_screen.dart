import 'package:flutter/material.dart';
import 'package:leetcode_notes/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'login_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    print('user: $user');
    if (user != null) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
