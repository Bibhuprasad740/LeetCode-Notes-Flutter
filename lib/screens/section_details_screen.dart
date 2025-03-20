import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/problem.dart';
import '../models/section.dart';
import '../providers/problem_provider.dart';
import '../providers/section_provider.dart';
import '../widgets/add_problem_form.dart';
import '../widgets/problem_card.dart';

class SectionDetailsScreen extends StatefulWidget {
  final String sectionId;
  const SectionDetailsScreen({
    super.key,
    required this.sectionId,
  });

  @override
  State<SectionDetailsScreen> createState() => _SectionDetailsScreenState();
}

class _SectionDetailsScreenState extends State<SectionDetailsScreen> {
  late Section section;
  late List<Problem> problems;
  bool isLoading = true;
  bool _isAddingNew = false;

  @override
  void initState() {
    super.initState();
    fetchProblems();
  }

  void fetchProblems() async {
    var sectionProvider = Provider.of<SectionProvider>(context, listen: false);
    var sections = sectionProvider.sections;
    section = sections.firstWhere((section) => section.id == widget.sectionId);

    var problemProvider = Provider.of<ProblemProvider>(context, listen: false);
    await problemProvider.getProblemsForSection(widget.sectionId);
    problems = problemProvider.problems;
    setState(() {
      isLoading = false;
    });
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat.yMMMd().format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    var problemProvider = Provider.of<ProblemProvider>(context);

    // Re-fetch problems when the provider changes
    if (!isLoading && problemProvider.problems != problems) {
      fetchProblems();
    }

    if (_isAddingNew) {
      return AddProblemForm(
        sectionId: widget.sectionId,
        onClose: () => setState(() => _isAddingNew = false),
        isEditing: false,
      );
    }

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await Future.delayed(const Duration(milliseconds: 300));
                  fetchProblems();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildSectionHeader(),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: problems.isEmpty
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.code_off,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No problems in this section yet',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add First Problem'),
                                      onPressed: () {
                                        setState(() => _isAddingNew = true);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ProblemCard(
                                      problem: problems[index],
                                      sectionId: section.id,
                                    ),
                                  );
                                },
                                childCount: problems.length,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
        floatingActionButton: !isLoading && problems.isNotEmpty
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isAddingNew = true;
                  });
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  Widget _buildSectionHeader() {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.primary.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                section.name,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Added on ${_formatDate(section.dateAdded)}',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatsChip(
                Icons.code,
                '${problems.length} ${problems.length == 1 ? 'Problem' : 'Problems'}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsChip(IconData icon, String label) {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium!.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
