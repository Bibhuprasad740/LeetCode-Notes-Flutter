import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/problem.dart';

class ProblemProvider extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: dotenv.env['BACKEND_BASE_URL'] ?? ''),
  );

  List<Problem> _problems = [];
  List<Problem> _allProblems = [];
  bool _isLoading = true;

  ProblemProvider() {
    getAllProblems();
  }

  List<Problem> get problems => _problems;
  List<Problem> get allProblems => _allProblems;
  bool get isLoading => _isLoading;

  Future<void> getProblemsForSection(String sectionId) async {
    _isLoading = true;
    try {
      final getProblemsForSectionEndPoint =
          '${dotenv.env['BACKEND_URL']!}${dotenv.env['getAllProblemsForSection']!}/$sectionId';

      final sharedPreference = await SharedPreferences.getInstance();
      final token = sharedPreference.getString('token');
      _dio.options.headers['authorization'] = 'Bearer $token';

      final response = await _dio.get(getProblemsForSectionEndPoint);

      if (response.statusCode == 200) {
        final problemsData = response.data;
        _problems = []; // Clear old data before adding new ones
        problemsData.forEach((problem) {
          _problems.add(Problem.fromJson(problem));
        });

        notifyListeners();
      }
    } catch (e) {
      _problems = [];
      print(
        'Error loading all problems for: $sectionId, $e',
      );
    }
    _isLoading = false;
  }

  Future<void> getAllProblems() async {
    try {
      final getAllProblemsEndPoint =
          '${dotenv.env['BACKEND_URL']!}${dotenv.env['getAllProblems']!}';
      final sharedPreference = await SharedPreferences.getInstance();
      final token = sharedPreference.getString('token');
      _dio.options.headers['authorization'] = 'Bearer $token';

      final response = await _dio.get(getAllProblemsEndPoint);
      if (response.statusCode == 200) {
        final problemsData = response.data;
        _allProblems = []; // Clear old data before adding new ones
        problemsData.forEach((problem) {
          _allProblems.add(Problem.fromJson(problem));
        });

        notifyListeners();
      }
    } catch (e) {
      _allProblems = [];
      print('Error loading all problems, $e');
    }
  }

  Future<void> updateProblem(Problem problem) async {
    try {
      final updateProblemEndPoint =
          '${dotenv.env['BACKEND_URL']!}${dotenv.env['updateProblem']!}/${problem.id}';

      final sharedPreference = await SharedPreferences.getInstance();
      final token = sharedPreference.getString('token');
      _dio.options.headers['authorization'] = 'Bearer $token';

      final response =
          await _dio.put(updateProblemEndPoint, data: problem.toJson());
      if (response.statusCode == 200) {
        notifyListeners();
      }
    } catch (e) {
      print('Error updating problem: $problem, $e');
    }
  }

  Future<void> addProblem(Problem problem) async {
    try {
      final addProblemEndPoint =
          '${dotenv.env['BACKEND_URL']!}${dotenv.env['addProblem']!}';

      final sharedPreference = await SharedPreferences.getInstance();
      final token = sharedPreference.getString('token');
      _dio.options.headers['authorization'] = 'Bearer $token';

      final response =
          await _dio.post(addProblemEndPoint, data: problem.toJson());
      if (response.statusCode == 201) {
        getProblemsForSection(problem.sectionId);
      }
    } catch (e) {
      print('Error adding problem: $problem, $e');
    }
  }

  Future<void> deleteProblem(Problem problem) async {
    try {
      final deleteProblemEndPoint =
          '${dotenv.env['BACKEND_URL']!}${dotenv.env['deleteProblem']!}/${problem.id}';

      final sharedPreference = await SharedPreferences.getInstance();
      final token = sharedPreference.getString('token');
      _dio.options.headers['authorization'] = 'Bearer $token';

      final response = await _dio.delete(deleteProblemEndPoint);
      if (response.statusCode == 204) {
        getProblemsForSection(problem.sectionId);
      }
    } catch (e) {
      print('Error deleting problem: ${problem.id}, $e');
    }
  }

  void clearData() {
    _problems = [];
    notifyListeners();
  }
}
