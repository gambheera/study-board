// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_sync_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContentSyncNotifier)
final contentSyncProvider = ContentSyncNotifierProvider._();

final class ContentSyncNotifierProvider
    extends $AsyncNotifierProvider<ContentSyncNotifier, void> {
  ContentSyncNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentSyncNotifierHash();

  @$internal
  @override
  ContentSyncNotifier create() => ContentSyncNotifier();
}

String _$contentSyncNotifierHash() =>
    r'cffa1fae6ae86a6db63dfbccc8b66c8912386551';

abstract class _$ContentSyncNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
