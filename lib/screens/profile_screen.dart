import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/section_provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final sectionProvider = Provider.of<SectionProvider>(context);
    final user = authProvider.user;
    user!.photoUrl = 'https://avatars.githubusercontent.com/u/56637943?v=4';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Image (replace with actual image loading)
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoUrl != null
                  ? NetworkImage(user!.photoUrl!)
                  : const AssetImage('assets/placeholder.png') as ImageProvider,
            ),
            const SizedBox(height: 20),

            // User Name
            Text(
              user?.name ?? 'Guest',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Email
            Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Total Sections
            _buildStatTile('Total Sections', sectionProvider.sections.length),
            const SizedBox(height: 10),

            // Total Problems
            _buildStatTile('Total Problems', sectionProvider.totalQuestions),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String title, int count) {
    return ListTile(
      leading: const Icon(Icons.circle),
      title: Text(title),
      trailing: Text('$count'),
    );
  }
}
