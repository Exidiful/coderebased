import 'package:flutter/material.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Placeholder count
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.notifications),
            ),
            title: Text('Notification ${index + 1}'),
            subtitle: const Text('This is a notification description'),
            trailing: Text(
              '${index + 1}h ago',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              // TODO: Handle notification tap
            },
          ),
        );
      },
    );
  }
}