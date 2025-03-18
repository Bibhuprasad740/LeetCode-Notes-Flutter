import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/problem_provider.dart';
import '../providers/section_provider.dart';
import '../providers/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  // Function to handle refresh
  Future<void> _refreshSections(BuildContext context) async {
    final sectionProvider =
        Provider.of<SectionProvider>(context, listen: false);
    await sectionProvider.getAllSections();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'assets/leetcode.png',
              height: 20,
              width: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'LeetCode Notes',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.dark_mode_outlined,
            color: Colors.indigo,
          ),
          onPressed: () {
            final themeProvider =
                Provider.of<ThemeProvider>(context, listen: false);
            themeProvider.toggleTheme();
          },
        ),
        IconButton(
          onPressed: () => _refreshSections(context),
          icon: const Icon(
            Icons.refresh,
          ),
        ),
        IconButton(
          onPressed: () async {
            // Show confirmation dialog
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to log out?'),
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
          icon: const Icon(Icons.logout),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
