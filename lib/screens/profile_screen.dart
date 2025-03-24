import 'package:flutter/material.dart';
import 'package:leetcode_notes/widgets/consistency_tracker.dart';
import 'package:provider/provider.dart';

import '../providers/problem_provider.dart';
import '../providers/section_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<DateTime, bool> activityData = {};

  void getActivityDataFromProblems() {
    final data = <DateTime, bool>{};
    final problemProvider =
        Provider.of<ProblemProvider>(context, listen: false);

    for (final problem in problemProvider.allProblems) {
      final problemDate = DateTime.parse(problem.dateAdded);
      final normalizedDate =
          DateTime(problemDate.year, problemDate.month, problemDate.day);
      data[normalizedDate] = true;
    }

    setState(() {
      activityData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getActivityDataFromProblems();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final sectionProvider = Provider.of<SectionProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final user = authProvider.user;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    user!.photoUrl = 'https://avatars.githubusercontent.com/u/56637943?v=4';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  height: size.height * 0.12,
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.1),
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),

                // Theme toggle positioned at top right
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(
                        themeProvider.isDarkMode
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => themeProvider.toggleTheme(),
                    ),
                  ),
                ),

                // Profile content
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20),
                  child: Column(
                    children: [
                      // Profile image with border
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.onSurface,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: user.photoUrl != null
                              ? NetworkImage(user.photoUrl!)
                              : const AssetImage('assets/placeholder.png')
                                  as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // User name with shadow for readability
                      Text(
                        user.name,
                        style:
                            theme.textTheme.bodyLarge!.copyWith(fontSize: 25),
                      ),
                      const SizedBox(height: 4),

                      // Email with semi-transparent look
                      Text(
                        user.email,
                        style:
                            theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Consistency tracker
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ConsistencyTracker(activityData: activityData),
            ),
          ),

          // Stats cards in a grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildListDelegate([
                _buildStatCard(
                  context,
                  icon: Icons.library_books_rounded,
                  title: 'Sections',
                  count: sectionProvider.sections.length,
                  color: theme.colorScheme.primary,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.assignment_rounded,
                  title: 'Problems',
                  count: sectionProvider.totalQuestions,
                  color: theme.colorScheme.secondary,
                ),
              ]),
            ),
          ),

          // Logout button at bottom
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(24),
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Show confirmation dialog
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirm Logout'),
                        content:
                            const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // Return false if canceled
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(true); // Return true if confirmed
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );

                  // If user confirms logout, call the logout method
                  if (shouldLogout == true) {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    final sectionProvider =
                        Provider.of<SectionProvider>(context, listen: false);
                    final problemProvider =
                        Provider.of<ProblemProvider>(context, listen: false);

                    authProvider.logout();
                    problemProvider.clearData();
                    sectionProvider.clearData();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error.withOpacity(0.8),
                  foregroundColor: theme.colorScheme.onSurface,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.logout_rounded),
                label: Text(
                  'Logout',
                  style: theme.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context,
      {required IconData icon,
      required String title,
      required int count,
      required Color color}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Icon with colored container
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: color,
              ),
            ),
            // Count with large font
            Text(
              count.toString(),
              style: theme.textTheme.bodyMedium,
            ),
            // Title with smaller font
            Text(
              title,
              style: theme.textTheme.bodyMedium!.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
