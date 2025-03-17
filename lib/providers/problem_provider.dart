import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/problem.dart';

class ProblemProvider extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: dotenv.env['BACKEND_BASE_URL'] ?? ''),
  );

  List<Problem> _problems = [];
  bool _isLoading = true;

  List<Problem> get problems => _problems;
  bool get isLoading => _isLoading;

  Future<void> getProblemsForSection(String sectionId) async {
    _isLoading = true;
    try {
      final getProblemsForSectionEndPoint =
          '${dotenv.env['BACKEND_URL']!}${dotenv.env['getAllProblems']!}/$sectionId';
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

  Future<void> updateProblem(Problem problem) async {
    try {
      final updateProblemEndPoint =
          '${dotenv.env['BACKEND_URL']!}${dotenv.env['updateProblem']!}/${problem.id}';
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
      final response = await _dio.delete(deleteProblemEndPoint);
      if (response.statusCode == 204) {
        getProblemsForSection(problem.sectionId);
      }
    } catch (e) {
      print('Error deleting problem: ${problem.id}, $e');
    }
  }
}
