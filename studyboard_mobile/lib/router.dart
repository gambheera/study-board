import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:studyboard_mobile/features/auth/presentation/login_screen.dart';
import 'package:studyboard_mobile/features/auth/presentation/onboarding_screen.dart';
import 'package:studyboard_mobile/features/auth/presentation/profile_screen.dart';
import 'package:studyboard_mobile/features/auth/presentation/register_screen.dart';
import 'package:studyboard_mobile/features/backlog/presentation/backlog_screen.dart';
import 'package:studyboard_mobile/features/board/presentation/board_screen.dart';
import 'package:studyboard_mobile/features/board/presentation/content_sync_notifier.dart';
import 'package:studyboard_mobile/features/dashboard/presentation/dashboard_screen.dart';
import 'package:studyboard_mobile/features/lesson/presentation/curiosity_screen.dart';
import 'package:studyboard_mobile/features/lesson/presentation/lesson_content_screen.dart';
import 'package:studyboard_mobile/features/sessions/presentation/session_tracker_notifier.dart';

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  final router = GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authValue = ref.read(authProvider);
      if (authValue.isLoading) return null;
      if (authValue.hasError) return '/login';

      final authState = authValue.value;
      final isLoggedIn =
          authState?.map(
            unauthenticated: (_) => false,
            authenticated: (_) => true,
          ) ??
          false;

      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToRegister = state.matchedLocation == '/register';
      final isGoingToOnboarding = state.matchedLocation == '/onboarding';

      if (!isLoggedIn) {
        if (!isGoingToLogin) return '/login';
        return null;
      }

      final student = authState!.mapOrNull(authenticated: (a) => a.student);
      final needsOnboarding = student?.district.isEmpty ?? false;

      if (needsOnboarding) {
        if (!isGoingToOnboarding) return '/onboarding';
        return null;
      }

      if (isGoingToLogin || isGoingToRegister || isGoingToOnboarding) {
        return '/board';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (_, _) => const MaterialPage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (_, _) => const MaterialPage(child: RegisterScreen()),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (_, _) => const MaterialPage(child: OnboardingScreen()),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (_, _) => const MaterialPage(child: ProfileScreen()),
      ),
      GoRoute(
        path: '/curiosity/:taskId',
        pageBuilder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          return MaterialPage(child: CuriosityScreen(taskId: taskId));
        },
      ),
      GoRoute(
        path: '/lesson/:taskId',
        pageBuilder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          return MaterialPage(child: LessonContentScreen(taskId: taskId));
        },
      ),
      GoRoute(
        path: '/quiz/:taskId',
        // Story 4.1 will replace this stub with the real QuizScreen
        pageBuilder: (_, _) => const MaterialPage(
          child: Scaffold(body: Center(child: Text('Quiz coming soon'))),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/board',
            pageBuilder: (_, _) => const NoTransitionPage(child: BoardScreen()),
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
  ref
    ..onDispose(notifier.dispose)
    ..onDispose(router.dispose);
  return router;
});

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listen(contentSyncProvider, (_, _) {})
      ..listen(sessionTrackerProvider, (_, _) {});
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
