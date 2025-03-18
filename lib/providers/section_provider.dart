import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/section.dart';

class SectionProvider extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: dotenv.env['BACKEND_BASE_URL'] ?? ''),
  );

  List<Section> _sections = [];
  int _totalQuestions = 0;
  bool _isLoading = true;

  List<Section> get sections => _sections;
  bool get isLoading => _isLoading;
  int get totalQuestions => _totalQuestions;

  SectionProvider() {
    getAllSections();
  }

  void incrementDecrementTotalQuestions(int value) {
    _totalQuestions += value;
    notifyListeners();
  }

  Future<void> getAllSections() async {
    _isLoading = true;
    try {
      final getAllSectionsEndPoint =
          dotenv.env['BACKEND_URL']! + dotenv.env['getAllSections']!;

      final sharedPreference = await SharedPreferences.getInstance();
      final token = sharedPreference.getString('token');
      _dio.options.headers['authorization'] = 'Bearer $token';

      final response = await _dio.get(getAllSectionsEndPoint);
      if (response.statusCode == 200) {
        _sections = [];
        _totalQuestions = 0;
        final sectionsData = response.data;
        sectionsData.forEach((sectionJson) {
          final section = Section.fromJson(sectionJson);
          _totalQuestions += section.numberOfQuestions;
          _sections.add(section);
        });
        notifyListeners();
      } else {
        _sections = [];
      }
    } catch (e) {
      _sections = [];
      print(
        'Error loading all sections: $e',
      );
    }
    _isLoading = false;
  }

  Future<void> addSection(String name) async {
    _isLoading = true;
    try {
      final addSectionEndPoint =
          dotenv.env['BACKEND_URL']! + dotenv.env['createSection']!;

      final sharedPreference = await SharedPreferences.getInstance();
      final token = sharedPreference.getString('token');
      _dio.options.headers['authorization'] = 'Bearer $token';

      final response = await _dio.post(
        addSectionEndPoint,
        data: {
          'name': name,
        },
      );
      if (response.statusCode == 201) {
        getAllSections();
      }
    } catch (e) {
      print(
        'Error adding new section: $e',
      );
    }
    _isLoading = false;
  }

  Future<void> updateSection(String id, String name) async {
    _isLoading = true;
    try {
      final updateSectionEndPoint =
          '${dotenv.env['BACKEND_URL']!}${dotenv.env['updateSection']!}/$id';

      final sharedPreference = await SharedPreferences.getInstance();
      final token = sharedPreference.getString('token');
      _dio.options.headers['authorization'] = 'Bearer $token';

      final response = await _dio.put(
        updateSectionEndPoint,
        data: {
          'name': name,
        },
      );
      if (response.statusCode == 200) {
        getAllSections();
      }
    } catch (e) {
      print(
        'Error updating section: $e',
      );
    }
    _isLoading = false;
  }

  Future<void> deleteSection(String id) async {
    _isLoading = true;
    try {
      final deleteSectionEndPoint =
          '${dotenv.env['BACKEND_URL']!}${dotenv.env['deleteSection']!}/$id';

      final sharedPreference = await SharedPreferences.getInstance();
      final token = sharedPreference.getString('token');
      _dio.options.headers['authorization'] = 'Bearer $token';

      final response = await _dio.delete(deleteSectionEndPoint);
      if (response.statusCode == 200) {
        getAllSections();
      } else {
        print(response);
      }
    } catch (e) {
      print(
        'Error deleting section: $e',
      );
    }
    _isLoading = false;
  }

  void clearData() {
    _sections = [];
    _totalQuestions = 0;
    notifyListeners();
  }
}
