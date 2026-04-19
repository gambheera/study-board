import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/features/auth/presentation/register_screen.dart';
import 'package:studyboard_mobile/features/backlog/presentation/backlog_screen.dart';
import 'package:studyboard_mobile/features/board/presentation/board_screen.dart';
import 'package:studyboard_mobile/features/dashboard/presentation/dashboard_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    // Story 1.8 replaces this with auth-aware redirect using
    // authStateStreamProvider.
    initialLocation: '/register',
    routes: [
      GoRoute(
        path: '/register',
        pageBuilder: (_, _) => const MaterialPage(child: RegisterScreen()),
      ),
      GoRoute(
        path: '/onboarding',
        // Story 1.9 replaces this placeholder with the real OnboardingScreen.
        pageBuilder: (_, _) =>
            const MaterialPage(child: _OnboardingPlaceholder()),
      ),
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/board',
            pageBuilder: (_, _) =>
                const NoTransitionPage(child: BoardScreen()),
          ),
          GoRoute(
            path: '/dashboard',
            pageBuilder: (_, _) =>
                const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: '/backlog',
            pageBuilder: (_, _) =>
                const NoTransitionPage(child: BacklogScreen()),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(context),
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.view_kanban_outlined),
            selectedIcon: Icon(Icons.view_kanban),
            label: 'Board',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Backlog',
          ),
        ],
      ),
    );
  }

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/dashboard')) return 1;
    if (location.startsWith('/backlog')) return 2;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/board');
      case 1:
        context.go('/dashboard');
      case 2:
        context.go('/backlog');
      default:
        assert(false, 'Unhandled NavigationBar index: $index');
    }
  }
}

class _OnboardingPlaceholder extends StatelessWidget {
  const _OnboardingPlaceholder();

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('Onboarding — coming in Story 1.9')),
      );
}
