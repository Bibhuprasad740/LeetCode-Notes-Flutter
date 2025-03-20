import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'section_provider.dart';

class AuthProvider extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: dotenv.env['BACKEND_BASE_URL'] ?? ''),
  );

  User? _user;
  String? _token;
  bool _isLoading = true;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;

  AuthProvider() {
    fetchUserFromLocalStorage();
  }

  Future fetchUserFromLocalStorage() async {
    final sharedPreference = await SharedPreferences.getInstance();

    final user = sharedPreference.getString("auth");
    if (user != null) {
      _user = User.fromJson(jsonDecode(user));
      _token = sharedPreference.getString("token");
      notifyListeners();
    }
    _isLoading = false;
  }

  Future setUserInLocalStorage(User user, String token) async {
    final sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setString("auth", jsonEncode(_user!.toJson()));
    await sharedPreference.setString("token", token);

    notifyListeners();
  }

  Future login(BuildContext context, String email, String password) async {
    try {
      final backendUrl = dotenv.env['BACKEND_URL'];
      final response = await _dio.post('$backendUrl/api/auth/login', data: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200) {
        _user = User.fromJson(response.data['user']);
        _token = response.data['token'];

        await setUserInLocalStorage(_user!, _token!);

        final sectionProvider =
            Provider.of<SectionProvider>(context, listen: false);

        await sectionProvider.getAllSections(); // Fetch sections

        notifyListeners();
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  // login with google
  Future loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print('Google sign-in aborted');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('Google sign in user: $googleUser');
      final accessToken = googleAuth.accessToken;
      print("Google auth $googleAuth");
      final signInUrl =
          dotenv.env['BACKEND_URL']! + dotenv.env['googleSignIn']!;
      final response = await _dio.post(
        signInUrl,
        data: {'accessToken': accessToken},
      );

      if (response.statusCode == 200) {
        _user = User.fromJson(response.data['user']);
        _token = response.data['token'];

        await setUserInLocalStorage(_user!, _token!);

        final sectionProvider =
            Provider.of<SectionProvider>(context, listen: false);

        await sectionProvider.getAllSections(); // Fetch sections

        notifyListeners();
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future register(
      BuildContext context, String name, String email, String password) async {
    try {
      final backendUrl = dotenv.env['BACKEND_URL'];
      final response = await _dio.post('$backendUrl/api/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      if (response.statusCode == 201) {
        _user = User.fromJson(response.data['user']);
        _token = response.data['token'];
        await setUserInLocalStorage(_user!, _token!);

        final sectionProvider =
            Provider.of<SectionProvider>(context, listen: false);

        await sectionProvider.getAllSections(); // Fetch sections

        notifyListeners();
      } else {
        print('Error: ${response.data['message']}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future logout() async {
    try {
      _user = null;
      _token = null;

      final sharedPreference = await SharedPreferences.getInstance();
      await sharedPreference.remove("auth");
      await sharedPreference.remove("token");

      notifyListeners();
    } catch (e) {
      print('Error: $e');
    }
  }
}
