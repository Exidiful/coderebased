import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Profile Header
        const Center(
          child: CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'John Doe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const Center(
          child: Text(
            '@johndoe',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 32),

        // Stats Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatColumn('Repositories', '12'),
            _buildStatColumn('Following', '48'),
            _buildStatColumn('Followers', '96'),
          ],
        ),
        const SizedBox(height: 32),

        // Menu Items
        _buildMenuItem(context, Icons.settings, 'Settings'),
        _buildMenuItem(context, Icons.help_outline, 'Help & Feedback'),
        _buildMenuItem(context, Icons.info_outline, 'About'),
        _buildMenuItem(context, Icons.logout, 'Sign Out'),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Handle menu item tap
        },
      ),
    );
  }
}