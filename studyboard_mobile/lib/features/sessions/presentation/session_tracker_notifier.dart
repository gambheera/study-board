import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:studyboard_mobile/features/sessions/data/session_provider.dart';

part 'session_tracker_notifier.g.dart';

@riverpod
class SessionTrackerNotifier extends _$SessionTrackerNotifier
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  @override
  Future<void> build() async {
    WidgetsBinding.instance
      ..removeObserver(this)
      ..addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      unawaited(ref.read(sessionRepositoryProvider).closeSession());
    });
    await _openSession();
  }

  Future<void> _openSession() async {
    final studentId = ref
        .read(authProvider)
        .value
        ?.mapOrNull(authenticated: (a) => a.student.id);
    if (studentId == null) return;
    await ref.read(sessionRepositoryProvider).openSession(studentId);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _backgroundedAt = clock.now();
        unawaited(ref.read(sessionRepositoryProvider).closeSession());
      case AppLifecycleState.resumed:
        final backgrounded = _backgroundedAt;
        _backgroundedAt = null;
        if (backgrounded != null &&
            clock.now().difference(backgrounded) >
                const Duration(minutes: 30)) {
          unawaited(_openSession());
        }
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }
}
