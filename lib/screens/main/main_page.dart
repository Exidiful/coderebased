import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/auth.dart';

final authStateProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  late Timer _timer;
  int _selectedIndex = 2;
  final List<Widget> _pages = [
    //const AppStorePage(),
    //const RepositoryList(),
    //const MyProjects(),
    //const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    ref.read(authStateProvider);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var authState = ref.watch(authStateProvider).status;

    if (authState == AuthStatus.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authState == AuthStatus.authenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_getAppBarTitle()),
          centerTitle: true,
          elevation: 0,
          actions: _getAppBarActions(),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
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
    } else {
      _timer = Timer(const Duration(seconds: 5), () {
        Navigator.of(context).pushReplacementNamed('/login');
      });

      return const Scaffold(
        body: Center(
          child: Text('You are unauthenticated to see this page'),
        ),
      );
    }
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
            onPressed: () => Navigator.of(context).pushNamed('/addApp'),
          ),
        ];
      case 1:
        return [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed('/addRepo'),
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
            onPressed: () {},
          ),
        ];
      case 2:
      default:
        return [];
    }
  }
}
