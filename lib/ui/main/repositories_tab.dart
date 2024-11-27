import 'package:flutter/material.dart';

class RepositoriesTab extends StatelessWidget {
  const RepositoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Placeholder count
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.book),
                    const SizedBox(width: 8),
                    Text(
                      'Repository ${index + 1}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'This is a description for Repository ${index + 1}. It contains details about the project and its purpose.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildRepoStat(context, Icons.circle, 'Dart'),
                    const SizedBox(width: 16),
                    _buildRepoStat(context, Icons.star_border, '${index * 10}'),
                    const SizedBox(width: 16),
                    _buildRepoStat(
                        context, Icons.fork_right, '${(index + 1) * 5}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRepoStat(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}