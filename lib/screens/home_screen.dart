import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/problem_provider.dart';
import '../providers/section_provider.dart';
import '../widgets/add_section_form.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/dashboard_stats.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _isAddingSection = false;

  Future<void> _refreshSections(BuildContext context) async {
    final sectionProvider =
        Provider.of<SectionProvider>(context, listen: false);
    await sectionProvider.getAllSections();

    final problemProvider =
        Provider.of<ProblemProvider>(context, listen: false);
    await problemProvider.getAllProblems();
  }

  @override
  void initState() {
    super.initState();
    _refreshSections(context);
  }

  @override
  Widget build(BuildContext context) {
    final sectionProvider = Provider.of<SectionProvider>(context);
    final sections = sectionProvider.sections;
    final totalQuestions = sectionProvider.totalQuestions;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _isAddingSection = true),
        backgroundColor: Colors.indigo,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshSections(context),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardStats(
                        sectionsCount: sections.length,
                        totalQuestions: totalQuestions,
                        completedQuestions:
                            0, // Replace with actual completed questions count
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Sections',
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                setState(() => _isAddingSection = true),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add New'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_isAddingSection)
                        AddSectionForm(onClose: () {
                          setState(() {
                            _isAddingSection = false;
                          });
                        }),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: sections.isEmpty
                    ? SliverToBoxAdapter(
                        child: EmptyState(
                          onAddSection: () =>
                              setState(() => _isAddingSection = true),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final section = sections[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: SectionWidget(section: section),
                            );
                          },
                          childCount: sections.length,
                        ),
                      ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}
