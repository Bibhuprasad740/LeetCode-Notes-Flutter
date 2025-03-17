import 'package:flutter/material.dart';

class ProblemDetailsScreen extends StatelessWidget {
  final String questionId;
  const ProblemDetailsScreen({
    super.key,
    required this.questionId,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Question Details Screen'),
      ),
    );
  }
}
