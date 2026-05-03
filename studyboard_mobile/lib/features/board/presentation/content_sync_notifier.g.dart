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
        isAutoDispose: true,
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
    r'001a1b5aea529e59b9d2a96131e2ccce61a66645';

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
