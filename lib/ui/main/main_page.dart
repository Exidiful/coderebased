import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_tab.dart';
import 'repositories_tab.dart';
import 'apps_tab.dart';
import 'notifications_tab.dart';
import 'profile_tab.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2;
  final List<Widget> _pages = [
    const AppsTab(),
    const RepositoriesTab(),
    const HomeTab(),
    const NotificationsTab(),
    const ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Apps';
      case 1:
        return 'Repositories';
      case 2:
        return 'Home';
      case 3:
        return 'Notifications';
      case 4:
        return 'Profile';
      default:
        return 'UTB Codebase';
    }
  }

  List<Widget> _getAppBarActions() {
    switch (_selectedIndex) {
      case 0:
        return [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/app/create'),
          ),
        ];
      case 1:
        return [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/repo/create'),
          ),
        ];
      case 3:
        return [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {},
          ),
        ];
      case 4:
        return [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, '/profile/edit'),
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        centerTitle: true,
        elevation: 0,
        actions: _getAppBarActions(),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Apps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Repositories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
