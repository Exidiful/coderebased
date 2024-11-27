import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/auth.dart';
import 'auth/login.dart';
import 'main/main_page.dart';

// Constants
const _splashDelay = Duration(seconds: 2);
const _logoSize = 200.0;

// Provider
final splashProvider = AutoDisposeAsyncNotifierProvider(() => SplashNotifier());

// State Notifier
class SplashNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    await ref.read(authProvider).checkAuthStatus();
  }
}

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state changes
    final authState = ref.watch(authProvider);

    // Handle auth state changes
    ref.listen<AuthService>(authProvider, (_, auth) {
      if (auth.status == AuthStatus.authenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (auth.status == AuthStatus.unauthenticated) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: _logoSize,
              height: _logoSize,
            ),
            const SizedBox(height: 20),
            if (authState.status == AuthStatus.loading)
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
