import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/section_provider.dart';

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
          onPressed: () => _refreshSections(context),
          icon: const Icon(
            Icons.refresh,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
