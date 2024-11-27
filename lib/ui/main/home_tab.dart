import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Trending Repositories'),
            subtitle: const Text('See what\'s popular in the community'),
            onTap: () {
              // TODO: Navigate to trending repositories
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Your Stars'),
            subtitle: const Text('Repositories you\'ve starred'),
            onTap: () {
              // TODO: Navigate to starred repositories
            },
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Recent Activity'),
            subtitle: const Text('Your recent interactions'),
            onTap: () {
              // TODO: Navigate to activity history
            },
          ),
        ),
      ],
    );
  }
}