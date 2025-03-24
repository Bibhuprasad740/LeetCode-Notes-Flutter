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

    // print('Fetched user from local storage is: $_user');
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
      final accessToken = googleAuth.accessToken;
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

  // googleUser = GoogleSignInAccount:{displayName: Bibhu Prasad Sahoo, email: sahoo.bibhuprasad740@gmail.com, id: 102697759799249608547, photoUrl: https://lh3.googleusercontent.com/a/ACg8ocK2n2IjsTKckR4DhmhkXgdRejwlum4c3ZUNcGJKB_u9ptjNs7sy, serverAuthCode: null}

  // googleAuth = GoogleSignInAuthentication:Instance of 'GoogleSignInTokenData'

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

  Future signupWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('Google sign-in aborted');
        return;
      }

      final signInUrl =
          dotenv.env['BACKEND_URL']! + dotenv.env['googleSignUp']!;
      final response = await _dio.post(
        signInUrl,
        data: {
          'name': googleUser.displayName ?? 'Google User',
          'email': googleUser.email,
          'googleId': googleUser.id,
        },
      );

      if (response.statusCode == 201) {
        _user = User.fromJson(response.data['user']);
        _token = response.data['token'];
        await setUserInLocalStorage(_user!, _token!);
        final sectionProvider =
            Provider.of<SectionProvider>(context, listen: false);

        await sectionProvider.getAllSections(); // Fetch sections

        notifyListeners();
      }
    } catch (e) {
      print('Error: $e');
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
