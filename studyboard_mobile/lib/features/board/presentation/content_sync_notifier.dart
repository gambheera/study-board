import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:studyboard_mobile/core/content_cache/content_cache_service.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_notifier.dart';
import 'package:studyboard_mobile/features/auth/presentation/auth_state.dart';
import 'package:studyboard_mobile/features/board/data/content_provider.dart';

part 'content_sync_notifier.g.dart';

@Riverpod(keepAlive: true)
class ContentSyncNotifier extends _$ContentSyncNotifier {
  @override
  Future<void> build() async {
    final authValue = ref.read(authProvider);
    final student = authValue.value?.mapOrNull(authenticated: (a) => a.student);
    if (student == null) return;

    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.any((r) => r != ConnectivityResult.none)) return;

    final result =
        await ref.read(contentRepositoryProvider).syncContent(student.id);

    result.fold(
      (_) => null,
      (_) {
        ref.invalidate(contentSeededProvider);
        unawaited(ref.read(contentCacheServiceProvider).prefetchAll());
      },
    );
  }
}
